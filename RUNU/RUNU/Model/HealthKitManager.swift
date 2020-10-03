//
//  HealthKitManager.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/10/01.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import Foundation
import HealthKit
import HealthKitUI

class healthKitManager {
    static var shared = healthKitManager()
    private let store = HKHealthStore()
    
    func register(completion: ((_ success: Bool?)-> Void)!) {
        if !HKHealthStore.isHealthDataAvailable() {
            completion(false)
            return
        }
        
        let shareType: Set<HKSampleType> = [
            HKSampleType.quantityType(forIdentifier: .bodyMass)!
        ]
        
        store.requestAuthorization(toShare: shareType, read: nil) { [weak self] (success, error) in
            if error != nil {
                completion(false)
                return
            }
            print("success")
            completion(true)
            
        }
    
    
    }

}
