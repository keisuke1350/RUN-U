//
//  TabListViewController.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/08/02.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit
import HealthKit
import Pastel
import Alamofire

class TabListViewController: UIViewController {
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    var workouts: [HKWorkout] = []
    
    let readDataTypes: Set<HKObjectType> =
        [
            HKWorkoutType.workoutType(),
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.healthKitStore.requestAuthorization(toShare: nil, read: readDataTypes) {
            (success, error) -> Void in
            if success == false {
                print("can't get permittion")
            } else {
                self.readRunningWorkOuts({ (results, error) -> Void in
                    if( error != nil ) {
                        print("Error reading workouts: \(String(describing: error?.localizedDescription))")
                        return;
                    }

                    self.workouts = results as! [HKWorkout]
                    DispatchQueue.main.async(execute: { () -> Void in
                        for workout in self.workouts {
                            // 以下のように変更する
                            let km_double = workout.totalDistance!.doubleValue(for: HKUnit.meter()) / 1000
                            let averagespeed = self.calcAverageSpeedForMeter(interval: workout.duration, distance: km_double)
                            self.postToSlack(
                                date: String(format: "%@ ~ %@", workout.startDate as CVarArg, workout.endDate as CVarArg),
                                distance: String(format: "%@", workout.totalDistance ?? "no data"),
                                time: String(format: "%@", self.stringFromTimeInterval(interval: workout.duration)),
                                pace: String(format: "%@ / km", averagespeed),
                                energy: String(format: "%@", workout.totalEnergyBurned ?? "no data")
                            )
                            break
                            // ここまで
                        }
                    });
                })
            }
        }
        
        //PastelViewの記述
        let pastelView = PastelView(frame: view.bounds)
        view.addSubview(pastelView)

        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight

        pastelView.animationDuration = 3.0

        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])

        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        if HKHealthStore.isHealthDataAvailable() {
//            print("対応")
//        } else {
//            print("非対応")
//        }
//
//        //読み込むデータ
//        let read = Set(arrayLiteral: HKObjectType.characteristicType(forIdentifier: .biologicalSex)!, //性別
//                       HKObjectType.characteristicType(forIdentifier: .bloodType)!) //血液型
//        //書き込むデータ
//        let write = Set(arrayLiteral: HKObjectType.quantityType(forIdentifier: .bodyMass)!) //体重
//
//        let healthStore = HKHealthStore()
//        healthStore.requestAuthorization(toShare: write, read: read, completion:  { (status, error) in
//            if status {
//                print("認証済み")
//            } else {
//                print(error?.localizedDescription ?? "認証拒否")
//            }
//        })
//
//        do {
//            //性別
//            let biologicalSex = try healthStore.biologicalSex()
//            switch biologicalSex.biologicalSex {
//                case .female:
//                    print("女性")
//                case .male:
//                    print("男性")
//                case .notSet:
//                    print("非設定")
//                default:
//                    print("エラー")
//                }
//                //血液型
//                let bloodType = try healthStore.bloodType()
//                switch bloodType.bloodType {
//                case .aPositive:
//                    print("A+")
//                case .aNegative:
//                    print("A-")
//                case .bPositive:
//                    print("B+")
//                case .bNegative:
//                    print("B-")
//                case .abPositive:
//                    print("AB+")
//                case .abNegative:
//                    print("AB-")
//                case .oPositive:
//                    print("O+")
//                case .oNegative:
//                    print("O-")
//                default:
//                    print("エラー")
//                }
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        let quantity = HKQuantity(unit: HKUnit.gramUnit(with: .kilo), doubleValue: 60) //60が体重
//        let quantityType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
//        let weightData = HKQuantitySample(type: quantityType, quantity: quantity, start: Date(), end: Date())
//        healthStore.save(weightData,withCompletion: { (success, error) in
//            if success {
//                print("書き込み成功")
//            } else {
//                print(error?.localizedDescription ?? "エラー")
//            }
//        })
//
//
//
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func readRunningWorkOuts(_ completion: (([AnyObject]?, NSError?) -> Void)!) {
    let predicate =  HKQuery.predicateForWorkouts(with: HKWorkoutActivityType.running)
    let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
    let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(),
                                    predicate: predicate,
                                    limit: 0,
                                    sortDescriptors: [sortDescriptor]) {
                                        (sampleQuery, results, error ) -> Void in
                                        if error != nil {
                                            print("Query Error")
                                        }
                                        completion!(results,error as NSError?)
    }
    self.healthKitStore.execute(sampleQuery)
    }
    
    func calcAverageSpeedForMeter(interval: TimeInterval, distance: Double) -> String {
        let ti = NSInteger(interval)
        let total_seconds = Int(Double(ti) / distance)
        let seconds = total_seconds % 60
        let minutes = (total_seconds / 60) % 60

        return String(format: "%d.%0.2d",minutes,seconds)
    }

    func stringFromTimeInterval(interval: TimeInterval) -> String {

        let ti = NSInteger(interval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)

        return String(format: "%dh %0.2dm %0.2ds",hours,minutes,seconds)
    }
    
    // 追加
    // AlamofireでSlackへJSONをPOSTする
    func postToSlack(date: String, distance: String, time: String, pace: String, energy: String) {
         let parameters: Parameters = [
             "attachments": [
                 [
                     "color": "#36a64f",
                     "text": "kei13さんはWorkoutを行いました。",
                     "fields": [
                         [
                             "title": "Date",
                             "value": date,
                             "short": true
                         ],
                         [
                             "title": "Distance",
                             "value": distance,
                             "short": true
                         ],
                         [
                             "title": "Time",
                             "value": time,
                             "short": true
                         ],
                         [
                             "title": "Pace",
                             "value": pace,
                             "short": true
                         ],
                         [
                             "title": "Energy Burn",
                             "value": energy,
                             "short": true
                         ]
                     ]
                 ]
             ]
         ]
         let headers: HTTPHeaders = [
             "Content-Type": "application/json"
         ]

        AF.request("[https://hooks.slack.com/services/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]",
                              method: .post,
                              parameters: parameters,
                              encoding: JSONEncoding.default,
                              headers: headers).responseString { response in print(response) }
        }

}
