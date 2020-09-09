//
//  TabListViewController.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/08/02.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit
import HealthKit

class TabListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.layer.zPosition = -1.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if HKHealthStore.isHealthDataAvailable() {
            print("対応")
        } else {
            print("非対応")
        }
        
        //読み込むデータ
        let read = Set(arrayLiteral: HKObjectType.characteristicType(forIdentifier: .biologicalSex)!, //性別
                       HKObjectType.characteristicType(forIdentifier: .bloodType)!) //血液型
        //書き込むデータ
        let write = Set(arrayLiteral: HKObjectType.quantityType(forIdentifier: .bodyMass)!) //体重
        
        let healthStore = HKHealthStore()
        healthStore.requestAuthorization(toShare: write, read: read, completion:  { (status, error) in
            if status {
                print("認証済み")
            } else {
                print(error?.localizedDescription ?? "認証拒否")
            }
        })
        
        do {
            //性別
            let biologicalSex = try healthStore.biologicalSex()
            switch biologicalSex.biologicalSex {
                case .female:
                    print("女性")
                case .male:
                    print("男性")
                case .notSet:
                    print("非設定")
                default:
                    print("エラー")
                }
                //血液型
                let bloodType = try healthStore.bloodType()
                switch bloodType.bloodType {
                case .aPositive:
                    print("A+")
                case .aNegative:
                    print("A-")
                case .bPositive:
                    print("B+")
                case .bNegative:
                    print("B-")
                case .abPositive:
                    print("AB+")
                case .abNegative:
                    print("AB-")
                case .oPositive:
                    print("O+")
                case .oNegative:
                    print("O-")
                default:
                    print("エラー")
                }
        } catch {
            print(error.localizedDescription)
        }
        
        let quantity = HKQuantity(unit: HKUnit.gramUnit(with: .kilo), doubleValue: 60) //60が体重
        let quantityType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let weightData = HKQuantitySample(type: quantityType, quantity: quantity, start: Date(), end: Date())
        healthStore.save(weightData,withCompletion: { (success, error) in
            if success {
                print("書き込み成功")
            } else {
                print(error?.localizedDescription ?? "エラー")
            }
        })
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
