//
//  numberPlate.swift
//  newOCRProject
//
//  Created by Kian on 4/9/1398 AP.
//  Copyright © 1398 Kian Anvari. All rights reserved.
//

import UIKit

class numberPlateVC: UIViewController , UITableViewDataSource , UITableViewDelegate{
    
    

    @IBOutlet weak var numberPlateTableView: UITableView!
    
    let numberPlates = ["1","2","3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberPlateTableView.dataSource = self
        numberPlateTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberPlates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = numberPlateTableView.dequeueReusableCell(withIdentifier: "numberPlateTableViewCellID", for: indexPath) as! numberPlateTVCell
        cell.numberPlateImage.image = UIImage(named: numberPlates[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SubmitFineVC.imageName = numberPlates[indexPath.row]
        navigationController?.popToRootViewController(animated: true)
        
    }

}
