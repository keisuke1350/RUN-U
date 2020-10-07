//
//  RUNUPoints.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/10/06.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import Foundation


class RUNUPoints{
    static let sharedInstance = RUNUPoints()
    
    var count: Int = 0
    
    let buyPoints: Int = 120
    
    private init() {
        //シングルトンであることを保証するためにprivateで宣言する
    }
    
    func addScore() {
        self.count += buyPoints
    }

}
