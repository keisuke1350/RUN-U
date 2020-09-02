//
//  selectViewController.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/07/31.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseUI
import PKHUD
import FirebaseAuth
import CryptoKit
import AuthenticationServices

class selectViewController: UIViewController,FUIAuthDelegate {
    
    fileprivate var currentNonce: String?
    
    @IBOutlet weak var AuthButton: UIButton!
    
    var authUI: FUIAuth {get { return FUIAuth.defaultAuthUI()!}}
    //認証に使用するプロバイダの選択
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
        FUIFacebookAuth(),
        FUIEmailAuth()
    ]
    
    var player = AVPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let path = Bundle.main.path(forResource: "RUNUback", ofType: "mov")
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        player.play()
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.repeatCount = 0
        playerLayer.zPosition = -1
        view.layer.insertSublayer(playerLayer, at: 0)
        //無限ループ
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { (notification) in
            
            self.player.seek(to: .zero)
            self.player.play()
        }
        
        //authUIのデリゲート
        self.authUI.delegate = self
        self.authUI.providers = providers
        AuthButton.addTarget(self, action: #selector(self.AuthButtonTapped(sender:)), for: .touchUpInside)
        
        //Sign in with apple 実装
        if #available(iOS 13.0, *){
            let appleIdButton = ASAuthorizationAppleIDButton(
                authorizationButtonType: .default, authorizationButtonStyle: .black
            )
            
            appleIdButton.addTarget(self, action: #selector(handleTap(_sender:)), for: .touchUpInside)
            //　レイアウトの設定
            appleIdButton.translatesAutoresizingMaskIntoConstraints = false
            //Viewに追加
            view.addSubview(appleIdButton)
            
            //AutoLayout設定
            //appleLoginButtonの中心を画面の中心にセットする
            appleIdButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            //appleIdButtonの幅は、親ビューの0.7倍
            appleIdButton.widthAnchor.constraint(equalTo: self.view.widthAnchor,multiplier: 0.7).isActive = true
            //appleLoginButtonの高さは40
            appleIdButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            appleIdButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -25.0).isActive = true
            
        }
        
//        if self.isLogin() == true {
//
//            //ログイン状態の時はスキップ
//        }else{
//            //まだログインしていない場合はログイン画面表示
//
//        }
        
        
        
    }
    
    
    //loginぶButtonを押した際の挙動を設定
    @available(iOS 13.0, *)
    @objc func handleTap(_sender: ASAuthorizationAppleIDButton) {
        //ランダムの文字列を生成
        let nonce = randomNonceString()
        //delegateで使用するため代入
        currentNonce = nonce
        //requestを生成
        let request = ASAuthorizationAppleIDProvider().createRequest()
        //sha256で変換したnonceをrequestのnonceにセット
        request.nonce = sha256(nonce)
        //controllerをインスタンスかする(delegateで使用するcontroller)
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
//    //ログイン認証されているかどうかを判定する関数
//    func isLogin() -> Bool {
//
//        //ログインしているユーザーかどうか判定
//        if Auth.auth().currentUser != nil {
//            return true
//        } else {
//            return false
//        }
//
//    }
    
    //randomにて文字列を生成する関数を作成
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    //SHA256を使用してハッシュ変換する関数を用意
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    
    
    @IBAction func handleBackViewButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func AuthButtonTapped(sender: AnyObject) {
        //FirebaseUIのViewの取得
        let authViewController = self.authUI.authViewController()
        //FirebaseUIのViewの表示
        self.present(authViewController,animated: true, completion: nil)
    }
    
    //認証画面から離れた時に呼ばれる(キャンセルボタン押下含む)
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        //認証に成功した場合
        if error == nil {
            HUD.flash(.success, onView: tabBarController?.view ,delay: 0)
            performSegue(withIdentifier: "CurrentUser", sender: nil)
            self.tabBarController?.tabBar.layer.zPosition = -1
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

//extensitonでdelegate関数に追記していく
extension selectViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    //認証が成功したときに呼ばれる関数
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //credentialが存在するかチェック
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
            
        }
        //nonceがセットされているかチェック
        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
            
        }
        //credentialからtokenが取得できるかチェック
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        //tokenのエンコードを失敗
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        //認証に必要なcredentialをセット
        let credential = OAuthProvider.credential(withProviderID: "apple.id", idToken: idTokenString, rawNonce: nonce)
        //Firebaseへのログイン実行
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                //PKHUDアニメーション
                HUD.flash(.labeledError(title: "予期せぬエラー", subtitle: "再度お試しください"),delay: 1)
                return
            }
            if let authResult = authResult {
                print(authResult)
                //PKHUDのアニメーション
                HUD.flash(.labeledSuccess(title: "ログイン完了", subtitle: nil), onView: self.view, delay: 1) { _ in
                    // 画面遷移など行う
//                    let vc = self.storyboard?.instantiateViewController(identifier: "TabBarControllerId") as! UITabBarController
                    self.performSegue(withIdentifier: "CurrentUser", sender: nil)
                    }
            }
        }
    }
    
    // delegateのプロトコルに設定されているため、書いておく
    func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

    // Appleのログイン側でエラーがあった時に呼ばれる
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // Handle error.
      print("Sign in with Apple errored: \(error)")
    }
}


