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
import FirebaseFirestore
import FirebaseStorage
import PKHUD
import GoogleMobileAds


class myProfileViewController: UIViewController {
    
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var profileImageButton: UIButton!
    
    
    @IBOutlet weak var runUPointButton: UIButton!
    @IBOutlet weak var snsShareButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    
    
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
        
        //プロフィール画像を編集
        profileImageButton.layer.cornerRadius = 50
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.lightGray.cgColor
        
        //プロフィール画像のアクション
        profileImageButton.addTarget(self, action: #selector(tappedProfileImageButton), for: .touchUpInside)
        
        //ボタンUI設定
        runUPointButton.layer.cornerRadius = 10.0
        runUPointButton.layer.borderColor = UIColor.white.cgColor
        runUPointButton.layer.borderWidth = 2.0
        snsShareButton.layer.cornerRadius = 10.0
        snsShareButton.layer.borderColor = UIColor.white.cgColor
        snsShareButton.layer.borderWidth = 2.0
        signOutButton.layer.cornerRadius = 10.0
        signOutButton.layer.borderColor = UIColor.white.cgColor
        signOutButton.layer.borderWidth = 2.0
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    @IBAction func tappedDeleteButton(_ sender: Any) {
        //アクションシートを表示する
        let aleartAction: UIAlertController = UIAlertController(title: nil, message: "退会してもよろしいでしょうか？", preferredStyle: UIAlertController.Style.alert)
        //はい
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) -> Void in
            print("OK")
            
           let user = Auth.auth().currentUser

           user?.delete() { error in
             if let error = error {
               // An error happened.
                print(error)
             } else {
               // Account deleted.
                HUD.flash(.labeledSuccess(title: "退会完了", subtitle: nil), onView: self.view, delay: 2) { _ in
                // 画面遷移など行う
                self.performSegue(withIdentifier: "firstPage", sender: nil)
             }
           }
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

//extensionでdelegateを追加
extension myProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @objc private func tappedProfileImageButton(){
        print("imageViewをタップしたよ")
        //アクションシートを表示する
        let alertsheet = UIAlertController(title: nil, message: "選択してください", preferredStyle: .actionSheet)
        //カメラを選んだ時
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            print("カメラが選択されました")
            self.presentPicker(sourceType: .camera)
        }
        //アルバムを選んだ時
        let albumAction = UIAlertAction(title: "アルバムから選択", style: .default) { (action) in
            print("アルバムが選択されました")
            self.presentPicker(sourceType: .photoLibrary)
        }
        //キャンセルの場合
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            print("キャンセルが選択されました")
        }
        
        //アラートシートにアクションを追加
        alertsheet.addAction(cameraAction)
        alertsheet.addAction(albumAction)
        alertsheet.addAction(cancelAction)
        
        present(alertsheet, animated: true)
    }
    
    //アルバムとカメラの画面を生成する関数
    func presentPicker(sourceType:UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            //ソースタイプが利用できる時
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            //デリゲート先に自らのクラスを指定
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            //画面を表示する
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("The SourceType is not found")
        }
        
    }
    
    //プロフィールの加工後の処理を記載
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
    }
        
        profileImageButton.setTitle("", for: .normal)
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.contentHorizontalAlignment = .fill
        profileImageButton.contentVerticalAlignment = .fill
        profileImageButton.clipsToBounds = true
        
        
        
        dismiss(animated: true, completion: nil)
        
    }

}
