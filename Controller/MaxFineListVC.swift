//
//  MaxFineListVC.swift
//  newOCRProject
//
//  Created by Kian on 4/9/1398 AP.
//  Copyright © 1398 Kian Anvari. All rights reserved.
//


import UIKit
import CoreData

class MaxFineListVC: UIViewController , UITableViewDataSource {

    @IBOutlet weak var maxFinesTableView: UITableView!
    var counts: [String: Int] = [:]
    var countsArray : [MaxFinesModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maxFinesTableView.dataSource = self
        maxFinesTableView.reloadData()
        //FinesDAO.instance.maxSelectFines()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        //FinesDAO.instance.maxSelectFines()
        countsArray = []
        counts.removeAll()
        calcuteMaxFines()
        maxFinesTableView.reloadData()
        
    }
    @IBAction func sharedBtnPreesed(_ sender: Any) {
        pdfDataWithTableView(tableView: maxFinesTableView)
    }
    
    
    func calcuteMaxFines(){
        SubmitFineVC.fines.forEach { counts[$0.numberPlate, default: 0] += 1 }
        print(counts)
        
        for (key, value) in counts {
            if value >= 4 {
                countsArray.append(MaxFinesModel(numberPlate: key, count: value))
            }
        }
        for (key, value) in counts {
            print("\(key) occurs \(value) time(s)")
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = maxFinesTableView.dequeueReusableCell(withIdentifier: "maxFineTableViewCellID", for: indexPath) as! maxFinesTBCell
        cell.numberPlateLbl.text = countsArray[indexPath.row].numberPlate
        cell.countOfFinesLbl.text = "\(countsArray[indexPath.row].count) جریمه"
        return cell
        
    }
    
    
    
    
    func pdfDataWithTableView(tableView: UITableView) {
        let priorBounds = tableView.bounds
        let fittedSize = tableView.sizeThatFits(CGSize(width:priorBounds.size.width, height:tableView.contentSize.height))
        tableView.bounds = CGRect(x:0, y:0, width:fittedSize.width, height:fittedSize.height)
        let pdfPageBounds = CGRect(x:0, y:0, width:tableView.frame.width, height:self.view.frame.height)
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds,nil)
        var pageOriginY: CGFloat = 0
        while pageOriginY < fittedSize.height {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
            UIGraphicsGetCurrentContext()!.saveGState()
            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsGetCurrentContext()!.restoreGState()
            pageOriginY += pdfPageBounds.size.height
        }
        UIGraphicsEndPDFContext()
        tableView.bounds = priorBounds
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("myDocument.pdf")
        pdfData.write(to: docURL as URL, atomically: true)
        
        print("oooooopppppppeeeeennnnnn")
        do {
            let data = try Data(contentsOf: docURL)
            
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "ExportDataVC") as! ExportData
            let webView = UIWebView(frame: CGRect(x:20,y:20,width:view.frame.size.width-40, height:view.frame.size.height-40))
            webView.load(data, mimeType: "application/pdf", textEncodingName:"", baseURL: docURL.deletingLastPathComponent())
            vc.view.addSubview(webView)
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        catch {
            // catch errors here
        }
        
        
        
    }
    

}
