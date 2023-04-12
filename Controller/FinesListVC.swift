//
//  FinesListVC.swift
//  newOCRProject
//
//  Created by Kian on 4/9/1398 AP.
//  Copyright © 1398 Kian Anvari. All rights reserved.
//

import UIKit
import CoreData

class FinesListVC: UIViewController , UICollectionViewDataSource {

    @IBOutlet weak var finesListCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finesListCollectionView.dataSource = self
        //FinesDAO.instance.selectFines()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        finesListCollectionView.reloadData()
        //FinesDAO.instance.selectFines()
    }

    @IBAction func sharedBtnPressed(_ sender: Any) {
        pdfDataWithTableView(tableView: finesListCollectionView)
    }
    
    @IBAction func filterBtnPressed(_ sender: Any) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        let alert = UIAlertController(title: "از این تاریخ تا به الان گزارشات گرفته میشود", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -90).isActive = true
        
        let ok = UIAlertAction(title: "تاریخ", style: .default) { (action) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //let dateString = dateFormatter.string(from: datePicker.date)
            self.checkDate(date: datePicker.date)
        }
        let cancel = UIAlertAction(title: "انصراف", style: .destructive, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clearFines(_ sender: Any) {
        SubmitFineVC.fines = []
        finesListCollectionView.reloadData()
    }
    
    
   
    func checkDate(date : Date) {
        for (i , item) in SubmitFineVC.fines.enumerated() {
            if item.dateCreated.isBetween(startDate: date, endDate: Date()){
                print(item.numberPlate)
            }else{
               // SubmitFineVC.fines.remove(at: i)
            }
        }
        
        finesListCollectionView.reloadData()
        
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SubmitFineVC.fines.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = finesListCollectionView.dequeueReusableCell(withReuseIdentifier: "FineListCollectionViewCellID", for: indexPath) as! finesListCVCell
        cell.numberPlate.text = SubmitFineVC.fines[indexPath.row].numberPlate
        cell.price.text = String(SubmitFineVC.fines[indexPath.row].price)
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let mydate = formatter.string(from : SubmitFineVC.fines[indexPath.row].dateCreated)
        cell.dateCreated.text = mydate
        return cell
        
    }
    
    
    
    
    func pdfDataWithTableView(tableView: UICollectionView) {
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



extension Date
{
    func isBetween(startDate:Date, endDate:Date)->Bool
    {
        return (startDate.compare(self) == .orderedAscending) && (endDate.compare(self) == .orderedDescending)
    }
}
