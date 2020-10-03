//
//  EventCreateViewController.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/09/26.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit
import RealmSwift

class EventCreateViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var titleTexttField: UITextField!
    @IBOutlet weak var memoTextField: UITextView!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    
    @IBOutlet weak var EventDate: UITextField!
    
    var datepicker: UIDatePicker = UIDatePicker()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTexttField.delegate = self
        startTextField.delegate = self
        endTextField.delegate = self
        memoTextField.delegate = self

        // Do any additional setup after loading the view.
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
    
    
    @IBAction func doneButton(_ sender: Any) {
        if titleTexttField.text != "" {
            if memoTextField.text != "" {
                let newEvent = EventModel.create()
                newEvent.title = titleTexttField.text!
                newEvent.memo = memoTextField.text!
                let today = EventModel.changeDateType(date: Date())
                newEvent.date = today
                newEvent.save()
                self.dismiss(animated: true, completion: nil)
                
            }else{
                SimpleAlert.showAlert(viewController: self, title: "メモなし", message: "内容を書いてください", buttonTitle: "OK")
            }
        }else{
            SimpleAlert.showAlert(viewController: self, title: "タイトルなし", message: "タイトルを書いてください", buttonTitle: "OK")
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
