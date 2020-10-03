//
//  SimpleAlert.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/09/27.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit

struct SimpleAlert {
    static func showAlert(viewController: UIViewController,title: String,message: String,buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
}
