//
//  EventCreateViewController.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/09/26.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit
import RealmSwift
import Pastel
import GoogleMobileAds

class EventCreateViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var titleTexttField: UITextField!
    @IBOutlet weak var memoTextField: UITextView!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var datepicker: UIDatePicker = UIDatePicker()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTexttField.delegate = self
        startTextField.delegate = self
        endTextField.delegate = self
        memoTextField.delegate = self

        // Do any additional setup after loading the view.
        
        memoTextField.layer.borderColor = UIColor.lightGray.cgColor
        memoTextField.layer.cornerRadius = 5
        memoTextField.layer.borderWidth = 1.0
        titleTexttField.layer.borderColor = UIColor.lightGray.cgColor
        titleTexttField.layer.borderWidth = 1.0
        endTextField.layer.borderColor = UIColor.lightGray.cgColor
        endTextField.layer.borderWidth = 1.0
        startTextField.layer.borderColor = UIColor.lightGray.cgColor
        startTextField.layer.borderWidth = 1.0
        
        
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
        
        //テスト用IDで広告表示
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        //値受け取り
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        date.text = appDelegate.message
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //キーボード入力設定
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func stringFromDate(date: Date, format: String) -> String {
            let formatter: DateFormatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
    
    
    @IBAction func doneButton(_ sender: Any) {
//        //パターン1
//        do {
//            let realm = try Realm()
//            let eventModel = EventModel()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            eventModel.title = titleTexttField.text ?? ""
//            eventModel.date = dateFormatter.string(from: Date())
//
//
//        }

        
        
        //パターン2
        if titleTexttField.text != "" {
            if memoTextField.text != "" {
                createEvent {
                    self.navigationController?.popViewController(animated: true)
                }
//                let realm = try! Realm()
//                let eventModel = EventModel()
//                let newEvent = EventModel.create()
//                newEvent.title = titleTexttField.text!
//                newEvent.memo = memoTextField.text!
//                let today = EventModel.changeDateType(date: Date())
//                newEvent.date = today
////                date.text = "\(today)"
//                newEvent.save()

            }else{
                SimpleAlert.showAlert(viewController: self, title: "メモなし", message: "内容を書いてください", buttonTitle: "OK")
            }
        }else{
            SimpleAlert.showAlert(viewController: self, title: "タイトルなし", message: "タイトルを書いてください", buttonTitle: "OK")
        }
    }
    
    func createEvent(success: @escaping() -> Void) {
        do {
            let realm = try Realm()
            let eventModel = EventModel()
            eventModel.title = titleTexttField.text ?? ""
            eventModel.memo = memoTextField.text
            eventModel.date = EventModel.changeDateType(date: Date())
            eventModel.start_time = startTextField.text ?? ""
            eventModel.end_time = endTextField.text ?? ""
            eventModel.id = lastId()
            
            try realm.write{
                realm.add(eventModel)
                success()
            }
        } catch {
            print("create todo error")
        }
        
        
    }
    
    func lastId() -> Int {
        let realm = try! Realm()
        if let object = realm.objects(EventModel.self).last {
            return object.id + 1
            
        } else {
            return 1
        }
    }

    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    func createEvent(success: @escaping() -> Void) {
//        do {
//            let realm = try Realm()
//            let eventModel = EventModel()
//            eventModel.title = titleTexttField.text ?? ""
//            eventModel.memo = memoTextField.text ?? ""
////            eventModel.date = stringFromDate(date: date as Date, format: "yyyy.MM.dd")
//            eventModel.start_time = startTextField.text ?? ""
//            eventModel.end_time = endTextField.text ?? ""
//
//            try realm.write {
//                realm.add(eventModel)
//                success()
//            }
//        } catch {
//            print("create todo error")
//        }
//
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
