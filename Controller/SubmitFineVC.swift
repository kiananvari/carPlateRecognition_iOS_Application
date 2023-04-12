//
//  ViewController.swift
//  newOCRProject
//
//  Created by Kian on 4/9/1398 AP.
//  Copyright © 1398 Kian Anvari. All rights reserved.
//


import UIKit
import TesseractOCR

class SubmitFineVC: UIViewController , G8TesseractDelegate  {
    
    
    @IBOutlet weak var numberPlateLable: UILabel!
    @IBOutlet weak var numberPlateBtn: UIButton!
    @IBOutlet weak var emptyNumber: UILabel!
    
    @IBOutlet weak var finesPrice: UITextField!
    
    static var imageName: String?
    
    let exceptionArray = ["IND-123-34","11-C-8290"]
    
    
    static var fines : [FinesModel] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        numberPlateBtn.imageView?.contentMode = .scaleAspectFit
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setupRecognition()
    }
    
    

    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false
    }

    
    func setup(){
        let closeTouchGesture = UITapGestureRecognizer(target: self, action: #selector(SubmitFineVC.closeTap(_:)))
        self.view.addGestureRecognizer(closeTouchGesture)
    }
    
    @objc func closeTap(_ Recognizer : UITapGestureRecognizer){
        finesPrice.endEditing(true)
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        if  exceptionArray.contains(SubmitFineVC.imageName!){
            let fines = FinesModel(pictureID: SubmitFineVC.imageName!
                , price: Int(finesPrice.text!) ?? 0, numberPlate: numberPlateLable.text!, dateCreated: Date())
            
            SubmitFineVC.fines.insert(fines, at: 0)
            
           // FinesDAO.instance.insertNewFines(fines)
            clearBtnPressed(self)
        }else{
            clearBtnPressed(self)
            numberPlateLable.text = "پلاک قابل ثبت نیست"
        }
        
        
    }
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        numberPlateBtn.setImage(UIImage(named: "numberPlateEmpty"), for: .normal)
        emptyNumber.isHidden = false
        numberPlateLable.text = ""
        finesPrice.text = ""
        SubmitFineVC.imageName = nil
        
    }
    
    func setupRecognition() {
        if let tesseract:G8Tesseract = G8Tesseract(language:"eng"){
            tesseract.delegate = self
            tesseract.charWhitelist = "BCDFGHJKLMNPQRSTVWXYZ0123456789-"
            if let image = SubmitFineVC.imageName {
                tesseract.image = UIImage(named: image)
                tesseract.recognize()
                guard tesseract.recognizedText != nil else {
                    self.numberPlateLable.text = "It couldn't be recognized"
                    return
                }
                numberPlateBtn.setImage(UIImage(named: image)
, for: .normal)
                emptyNumber.isHidden = true
                
                 self.numberPlateLable.text = tesseract.recognizedText
            }
            
        }
    }
    
    
}

