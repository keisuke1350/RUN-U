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
        profileImageButton.layer.cornerRadius = 85
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.lightGray.cgColor
        
        //registerButtonを編集
        registerButton.layer.cornerRadius = 15
        
        //プロフィール画像のアクション
        profileImageButton.addTarget(self, action: #selector(tappedProfileImageButton), for: .touchUpInside)
        
        //registerButtonのアクション
        registerButton.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)
        
        //extensionで書いたコードのデリゲート先を記載
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        //はじめはregisterbuttonを無効化しておく
        registerButton.isEnabled = false
        registerButton.backgroundColor = .init(red:255, green:0,blue:0,alpha:1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationbarは非表示
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //キーボード以外の場所を触れてキーボードを閉じる設定
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func tappedRegisterButton () {
        guard let image = profileImageButton.imageView?.image else { return }
        //imageをサイズ圧縮するために書く
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)

        storageRef.putData(uploadImage, metadata: nil) { (metadata, err) in
            if let err = err {
            print("Firestorageへの情報の保存に失敗しました\(err)")
            return
            }
            
            print("Firestorageへの情報の保存に成功しました。")
            storageRef.downloadURL { (url, err) in
                if let err = err {
                    print("FireStorageからのダウンロードに失敗しました\(err)")
                    return
                }
                
                guard let urlString = url?.absoluteString else { return }
                print("urlString:", urlString)
                self.createUserToFirestore(profileImageUrl: urlString)
            }
        }
        
    }
    
    private func createUserToFirestore(profileImageUrl: String){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("認証情報の保存に失敗しました\(err)")
                return
            }
            
            print("認証情報の保存に成功しました")
            
            guard let uid = res?.user.uid else { return }
            guard let username = self.usernameTextField.text else { return }
            let docData = [
                "email":email,
                "username":username,
                "createdAt":Timestamp(),
                "profileImageUrl":profileImageUrl
            ]  as [String : Any]
            
            //usersというコレクションの中に保存
            Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                if let err = err {
                    print("Firestoreへの保存に失敗しました。\(err)")
                    return
                }
                
                print("Firestoreへの情報の保存が成功しました")
                self.dismiss(animated: true, completion: nil)
            }
               
        }
        
        
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

extension registerViewController:UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        //各項目が空の場合を定義
        let emailIsEmpty = emailTextField.text?.isEmpty ?? false
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? false
        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? false
        
        //もしいずれかが空であれば
        if emailIsEmpty || passwordIsEmpty || usernameIsEmpty {
            //registerButtonを無効化
            registerButton.isEnabled = false
            //ボタンの色を変える
            registerButton.backgroundColor = .init(red:100,green:100,blue:100,alpha: 1)
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .init(red: 0, green:185, blue: 0, alpha: 1)
        }
    }

}

//extensionでdelegateを追加
extension registerViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
