//
//  DataManager.swift
//  Currency
//
//  Created by gamal oraby on 01/06/2023.
//
import Foundation
import UIKit
import CoreData

class DataManager {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    func createEntity (entityName: String, rate: CurencyRate) {
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let newRate = NSManagedObject(entity: entity!, insertInto: context)
        newRate.setValue(rate.currencyFromCode, forKey: "currencyFromCode")
        newRate.setValue(rate.currencyToCode, forKey: "currencyToCode")
        newRate.setValue(rate.amount, forKey: "amount")
        newRate.setValue(rate.day, forKey: "day")
        newRate.setValue(rate.currencyFromRate, forKey: "currencyFromRate")
        newRate.setValue(rate.enterdAmount, forKey: "enteredAmount")
        do {
          try context.save()
         } catch {
          print("Error saving")
        }
    }
    
    func fetchData(entityName: String) -> [Rate]? {
        let request = NSFetchRequest<Rate>(entityName: entityName)
        let context = appDelegate.persistentContainer.viewContext
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            print("Failed")
            return nil
        }
    }
    
    func clearDtat() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Rate")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let context = appDelegate.persistentContainer.viewContext
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("error in delete")
        }
    }
    
    
}
