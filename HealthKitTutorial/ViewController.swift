//
//  ViewController.swift
//  HealthKitTutorial
//
//  Created by Dustin on 2020/07/22.
//  Copyright © 2020 Dustin. All rights reserved.
//

import UIKit
import HealthKit



class ViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    
    
    let healthStore = HKHealthStore()
    let healthKitTypesToRoad : Set<HKObjectType> = [
        HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!
        
    ]
    let healthKitTypesToWrite : Set<HKSampleType> = []

    var age: Int?
    var bloodType: HKBloodTypeObject?
    var name : String?
    

    func readProfile() -> (age: Int? , bloodtype: HKBloodTypeObject?) {

        
        do {
            let birthDay = try healthStore.dateOfBirthComponents()
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            
            age = currentYear - birthDay.year!
        } catch {}
        
        do {
            bloodType = try healthStore.bloodType()
        } catch {}
        
        do {
            
        }
       
        return (age,bloodType)

    }
    
    func getReadableBloodType(bloodType:HKBloodType?)-> String {
        var bloodTypeText = ""
        
        if bloodType != nil {
            
            switch bloodType {
            case .notSet:
                bloodTypeText = "Unknown"
            case .aPositive:
                bloodTypeText = "A+"
            case .aNegative:
                bloodTypeText = "A-"
            case .bPositive:
                bloodTypeText = "B+"
            case .bNegative:
                bloodTypeText = "B-"
            case .abPositive:
                bloodTypeText = "AB+"
            case .abNegative:
                bloodTypeText = "AB-"
            case .oPositive:
                bloodTypeText = "O+"
            case .oNegative:
                bloodTypeText = "O-"
            default:
                break;
        }
        
    }
        return bloodTypeText
    }
    
    
    
    @IBAction func callData(_ sender: UIButton) {
        
        let (age, bloodType) = readProfile()
        
        self.ageLabel.text = "\(age!)"
        self.bloodTypeLabel.text = getReadableBloodType(bloodType: bloodType?.bloodType)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !HKHealthStore.isHealthDataAvailable() {
            print("Error")
            return
        }
        
        healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRoad) { (success, error) in
            print("Success")
            
        }
    }


}



