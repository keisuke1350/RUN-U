//
//  EventModel.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/09/24.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import Foundation
import Realm
import RealmSwift


class EventModel: Object {
    
    static let realm = try! Realm()
    
    //EventModelのプロパティを定義
    

    @objc dynamic private var id = 0
    @objc dynamic var title = ""
    @objc dynamic var memo = ""
    @objc dynamic var date = ""
    @objc dynamic var start_time = ""
    @objc dynamic var end_time = ""
    
    //dateをprimary Keyに設定　（重複しないキー）
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //新規作成
    static func create() -> EventModel {
        let eventModel = EventModel()
        eventModel.id = lastId()
        return eventModel
    }
    
    //日付指定で読み込み
    static func search(date: Date) -> [EventModel] {
        let selectDay = EventModel.changeDateType(date: date)
        let config = Realm.Configuration( schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
            }
        })
        Realm.Configuration.defaultConfiguration = config
        if realm.objects(EventModel.self).filter("date == '\(selectDay)'").isEmpty == false {
            let objects = realm.objects(EventModel.self).filter("date == '\(selectDay)'")
            var EventModelArray: [EventModel] = []
            for object in objects {
                EventModelArray.append(object)
            }
            return EventModelArray
        } else {
            return []
        }
        
    }
    
    //Idの設定
    static func lastId() -> Int {
        if let object = realm.objects(EventModel.self).last {
            return object.id + 1
            
        } else {
            return 1
        }
    }
    
    //保存
    func save() {
        try! EventModel.realm.write {
            EventModel.realm.add(self)
        }
    }
    
    //日付のフォーマット指定
    static func changeDateType(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM月dd日"
        let text = dateFormatter.string(from: date)
        return text
        
    }
    
    //疑問
    //Realmからデータ削除
    func deleteModel(date:Date, indexPath:IndexPath) {
        let results = realm?.objects(EventModel.self).filter("date == '\(date)'")
        do {
            try realm?.write {
                realm?.delete(results![indexPath.row])
            }
            
        } catch {
            print("delte data error")
        }
        
    }
    
    
}
