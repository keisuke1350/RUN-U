//
//  CalenderViewController.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/08/08.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit
import Pastel
import CalculateCalendarLogic
import FSCalendar
import RealmSwift
import GoogleMobileAds

class CalenderViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var changeButton: UIBarButtonItem!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var EventModelTableView: UITableView!
    @IBOutlet weak var BannerView: GADBannerView!
    
    
    
    
    var EventModelArray: [EventModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        
        //デリゲート設定
        self.calendar.dataSource = self
        self.calendar.delegate = self
        self.EventModelTableView.delegate = self
        self.EventModelTableView.dataSource = self
        
        //日付表示設定
        Date.text = "カレンダーをタップ"
        Date.font = UIFont.systemFont(ofSize: 20.0)
        Date.textColor = .black
        view.addSubview(Date)
        
        configureTableView()
        
        EventModelArray = EventModel.search(date: Foundation.Date())
        //複数選択可能
        EventModelTableView.allowsMultipleSelection = true
        
        //テスト用IDで広告表示
        BannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        BannerView.rootViewController = self
        BannerView.load(GADRequest())
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(true, animated: false)
        
        EventModelArray = EventModel.search(date: Foundation.Date())
        EventModelTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dataFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    //祝日判定を行い結果を返すメソッド（true:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        //祝日判定を行う日にちの年月日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        //CalculateCalenderLogic():祝日判定のインスタンスの作成
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    //曜日判定(日曜日:1~土曜日7）
    func getWeekIdx(_ date: Date) -> Int {
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    //土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 { //日曜日
            return UIColor.red
        }
        else if weekday == 7 { //土曜日
            return UIColor.blue
        }
        
        return nil
        
    }
    
    //calendarの表示形式変更
    
    @IBAction func changeButtonAction(_ sender: Any) {
        if calendar.scope == .month {
            calendar.setScope(.week, animated: true)
            changeButton.title = "月表示"
            //calendatを更新
            calendar.reloadData()
        } else if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            changeButton.title = "週表示"
            //calendarを更新
            calendar.reloadData()
        }
        
        
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    
    @IBAction func weekMonthButton(_ sender: Any) {
        if calendar.scope == .month {
            calendar.setScope(.week, animated: true)
            changeButton.title = "月表示"
            //calendatを更新
            calendar.reloadData()
        } else if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            changeButton.title = "週表示"
            //calendarを更新
            calendar.reloadData()
        }
    }
    
    //イベントドットの実装
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let date = EventModel.changeDateType(date: date)
        var hasEvent:Bool = false
        for eventModel in EventModelArray {
            if eventModel["date"] as! String == date {
                hasEvent = true
            }
            
        }
        if hasEvent {
            return 1
        } else {
            return 0
        }
    }
    
    //カレンダータップで日付取得
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        Date.text = "\(year)年\(month)月\(day)日"
        view.addSubview(Date)
        
        //日付選択時に呼ばれるメソッド
        EventModelArray = EventModel.search(date: date)
        EventModelTableView.reloadData()
        
    }
    
    func getModel () {
        let realm = try! Realm()
        let results = realm.objects(EventModel.self)
        var eventModels: [[String:String]] = []
        for result in results {
            eventModels.append(["title": result.title,
                                "memo": result.memo,
                                "date":result.date,
                                "start_time": result.start_time,
                                "end_time": result.end_time])
        }
    }

    
    //nextEventへの画面遷移
    
    @IBAction func createEventButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.message = Date.text
        let nextVC = self.storyboard?.instantiateViewController(identifier: "Next") as! EventCreateViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func configureTableView () {
        
        //デリゲート設定
        EventModelTableView.delegate = self
        EventModelTableView.dataSource = self
        
        //セルの高さを30で固定
        EventModelTableView.rowHeight = 30.0
        
        //余白を消す
        EventModelTableView.tableFooterView = UIView()
        
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

extension CalenderViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventModelCell")!
        cell.textLabel?.text = EventModelArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //チェックマークを実装
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .checkmark
        
        
        //detailViewへ遷移
//        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    //セルの選択が外れたときに呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        //チェックマークを外す
        cell?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //セルの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            EventModelArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            //日付選択時に呼ばれるメソッド
//            EventModelArray = EventModel.deleteModel(date: Date,indexPath: indexPath)
            EventModelTableView.reloadData()
            
        }
    }
    
    
}
