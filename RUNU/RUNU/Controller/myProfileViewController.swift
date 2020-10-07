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
import SwiftyStoreKit


class myProfileViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
//    id838344242424242455
//    b33f3746c7f04e3c9be0eafcf5796bdd

    
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var profileImageButton: UIButton!
    
    
    @IBOutlet weak var runUPointButton: UIButton!
    @IBOutlet weak var snsShareButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
 
    @IBOutlet weak var sdgsImage1: UIImageView!
    @IBOutlet weak var sdgsImage2: UIImageView!
    @IBOutlet weak var sdgsImage3: UIImageView!
    
    
    @IBOutlet weak var sdgsText1: UITextField!
    @IBOutlet weak var sdgsText2: UITextField!
    @IBOutlet weak var sdgsText3: UITextField!
    
    
    @IBOutlet weak var RUNUpoints: UILabel!
    
    //pickerView表示項目作成
    var pickerView: UIPickerView = UIPickerView()
    let picklist = ["",
                    "1 貧困を無くそう",
                    "2 飢餓をゼロに",
                    "3 すべての人に健康と福祉を",
                    "4 室の高い教育をみんなに",
                    "5 ジェンダー平等を実現しよう",
                    "6 安全な水とトイレを世界中に",
                    "7 エネルギーをみんなに そしてクリーンに",
                    "8 働きがいも経済成長も",
                    "9 産業と技術革新の基盤をつくろう",
                    "10 人や国の不平等を無くそう",
                    "11 住み続けられるまちづくりを",
                    "12 つくる責任 つかう責任",
                    "13 気候変動に具体的な対策を",
                    "14 海の豊かさを守ろう",
                    "15 陸の豊かさも守ろう",
                    "16 平和と公正をすべての人に",
                    "17 パートナーシップで目標を達成しよう"
                    ]
    
    private let photos = ["sdgs", "sdgs01", "sdgs02", "sdgs03", "sdgs04", "sdgs05","sdgs06", "sdgs07", "sdgs08", "sdgs09", "sdgs10", "sdgs11", "sdgs12", "sdgs13", "sdgs14", "sdgs15", "sdgs16", "sdgs17"]
    
    var imageArray = [UIImage?]()
    let Max_ARRAY_NUM = 18
    
    
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
        
        //pickerViewデリゲート設定
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //picker設定
        self.sdgsText1.text = picklist[0]
        self.sdgsText2.text = picklist[0]
        self.sdgsText3.text = picklist[0]
        
        let toolbar1 = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(myProfileViewController.done1))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(myProfileViewController.cancel1))
        toolbar1.setItems([cancelItem,doneItem], animated: true)
        
        let toolbar2 = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(myProfileViewController.done2))
        let cancelItem2 = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(myProfileViewController.cancel2))
        toolbar2.setItems([cancelItem2,doneItem2], animated: true)
        
        let toolbar3 = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem3 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(myProfileViewController.done3))
        let cancelItem3 = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(myProfileViewController.cancel3))
        toolbar3.setItems([cancelItem3,doneItem3], animated: true)
        
        self.sdgsText1.inputView = pickerView
        self.sdgsText1.inputAccessoryView = toolbar1
        
        self.sdgsText2.inputView = pickerView
        self.sdgsText2.inputAccessoryView = toolbar2
        
        self.sdgsText3.inputView = pickerView
        self.sdgsText3.inputAccessoryView = toolbar2
        
        for i in 0 ..< Max_ARRAY_NUM {
            let image = UIImage(named: photos[i])
            imageArray.append(image)
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
        
        if let buy = UserDefaults.standard.object(forKey: "buy"){
            //何かデータが入っていたら
            let count:Int = buy as! Int
            RUNUpoints.text = String(count)
            
        } else {
            //何もキー値に入っていない場合
            UserDefaults.standard.set(Int(RUNUpoints.text!),forKey: "buy")
            
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
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
    
    //pickeView設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picklist.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picklist[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sdgsText1.text = picklist[row]
        self.sdgsImage1.image = imageArray[row]
    }
    @objc func done1(){
        self.sdgsText1.endEditing(true)
    }
    
    @objc func cancel1(){
        self.sdgsText1.text = ""
        self.sdgsText1.endEditing(true)
    }
    
    @objc func done2(){
        self.sdgsText2.endEditing(true)
    }
    
    @objc func cancel2(){
        self.sdgsText2.text = ""
        self.sdgsText2.endEditing(true)
    }
    
    @objc func done3(){
        self.sdgsText3.endEditing(true)
    }
    
    @objc func cancel3(){
        self.sdgsText3.text = ""
        self.sdgsText3.endEditing(true)
    }
    
    
    
    //アプリ内課金
    func purchase(PRODUCT_ID:String){
        SwiftyStoreKit.purchaseProduct(PRODUCT_ID) { (result) in
            switch result {
            case .success(_):
                //購入が成功
                //購入の検証もする
                
                self.verifyPurchase(PRODUCT_ID: PRODUCT_ID)
                break
            case .error(_):
                //購入失敗
                break
            }
        }
    }
    
    func verifyPurchase(PRODUCT_ID:String){
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "b33f3746c7f04e3c9be0eafcf5796bdd")
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { (result) in
            
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: PRODUCT_ID, inReceipt: receipt)
                
                switch  purchaseResult {
                    //リストア成功
                    //購入があったら
                    case .purchased:
                        
                        if let buy = UserDefaults.standard.object(forKey: "buy"){
                        var count = UserDefaults.standard.object(forKey: "buy") as! Int
                        
                        count = count + 120
                        UserDefaults.standard.set(count, forKey: "buy")
                        self .RUNUpoints.text = String(count)
                        }
                        break
                case .notPurchased:
                    //アラート
                    break
                        
                        
                }
                
            case .error(let error):
                
                //エラー
                print(error)
                break
            }
        }
        
    }
    
    
    @IBAction func buyRUNUPoints(_ sender: Any) {
        
        purchase(PRODUCT_ID: "838344242424242455")
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
