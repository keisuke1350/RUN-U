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

class selectViewController: UIViewController,FUIAuthDelegate {
    
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
            let vc = TabListViewController()
            navigationController?.pushViewController(vc, animated: true)
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
