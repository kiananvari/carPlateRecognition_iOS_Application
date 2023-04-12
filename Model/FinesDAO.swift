//import CoreData
//import Foundation
//import UIKit
//
//class FinesDAO{
//
//    static let instance = FinesDAO()
//    let appDelegate = UIApplication.shared.delegate as!AppDelegate
//
////    func insertNewFines(_ Model : FinesModel){
////        let managedContext = appDelegate.persistentContainer.viewContext
////        let FinesEntity = NSEntityDescription.entity(forEntityName: "Fines", in: managedContext)!
////        let fmc = NSManagedObject(entity: FinesEntity, insertInto: managedContext)
////        fmc.setValue(Model.pictureID, forKey: "pictureID")
////        fmc.setValue(Model.dateCreated, forKey: "date")
////        fmc.setValue(Model.numberPlate, forKey: "numberPlate")
////        fmc.setValue(Model.price, forKey: "price")
////
////        do {
////            try managedContext.save()
////        } catch{
////            print("something is wrong \(error)")
////        }
////        FinesListVC.finesListArray.insert(fmc, at: 0)
////    }
////
////    func selectFines(){
////
////        let managedContext = appDelegate.persistentContainer.viewContext
////        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Fines")
////
////        do {
////            FinesListVC.finesListArray = try managedContext.fetch(fetchRequest)
////        } catch  {
////            print("error we can't fetch data")
////        }
////
////
////    }
//
//    func maxSelectFines(){
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Fines")
//        let keypathExp = NSExpression(forKeyPath: "numberPlate") // can be any column
//        let expression = NSExpression(forFunction: "count:", arguments: [keypathExp])
//
//        let countDesc = NSExpressionDescription()
//        countDesc.expression = expression
//        countDesc.name = "count"
//        countDesc.expressionResultType = .integer64AttributeType
//        fetchRequest.returnsObjectsAsFaults = false
//        fetchRequest.propertiesToGroupBy = ["numberPlate"]
//        fetchRequest.propertiesToFetch = ["numberPlate", countDesc]
//        fetchRequest.resultType = .managedObjectResultType
//
//
//        do {
//            MaxFineListVC.maxfinesListArray = try managedContext.fetch(fetchRequest)
//            print(MaxFineListVC.maxfinesListArray)
//        } catch  {
//            print("error we can't fetch data")
//        }
//
////
////        do {
////            let results = try managedContext.fetch(fetchRequest)
////
////            if results.count > 0 {
////                for result in results as! [NSManagedObject] {
////                    if let listName = result.value(forKey: "listName") {
////                        listArr.append(listName as! String)
////                    }
////                }
////            }
////        } catch  {
////            print("error we can't fetch data")
////        }
//
//
//    }
//
//
//}
