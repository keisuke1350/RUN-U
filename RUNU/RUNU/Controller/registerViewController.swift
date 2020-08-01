//
//  registerViewController.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/07/31.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseUI
import FirebaseAuth
import TextFieldEffects

class registerViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var emailTextField: KaedeTextField!
    @IBOutlet weak var passwordTextField: KaedeTextField!
    @IBOutlet weak var usernameTextField: KaedeTextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var alreadyHaveAcountButton: UIButton!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //テスト用IDで広告表示
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        //プロフィール画像を編集
        profileImageButton.layer.cornerRadius = 15
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.lightGray.cgColor
        
        //registerButtonを編集
        registerButton.layer.cornerRadius = 15
        
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
