//
//  myProfileViewController.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/08/21.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit
import Pastel
import FirebaseUI
import FirebaseAuth
import Firebase
import PKHUD

class myProfileViewController: UIViewController {
    
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //テスト用IDで広告表示
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
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
    
    @IBAction func tappedSignOutButton(_ sender: Any) {
        
        //アクションシートを表示する
        let aleartAction: UIAlertController = UIAlertController(title: nil, message: "サインアウトしてもよろしいでしょうか？", preferredStyle: UIAlertController.Style.alert)
        //はい
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) -> Void in
            print("OK")
            
           do {
                try Auth.auth().signOut()
                HUD.flash(.labeledSuccess(title: "サインアウト完了", subtitle: nil), onView: self.view, delay: 2) { _ in
                // 画面遷移など行う
                self.performSegue(withIdentifier: "firstPage", sender: nil)
                }
                
            } catch let signOutError as NSError {
                print("Error: \(signOutError)")
            }
        })
        
        //キャンセル
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:  { (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        //UIAleartControllerにActionを追加
        aleartAction.addAction(defaultAction)
        aleartAction.addAction(cancelAction)
        
        //alert表示
        present(aleartAction, animated: true, completion: nil)
        
    }

    
}
