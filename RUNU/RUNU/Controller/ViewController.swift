//
//  ViewController.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/07/29.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit
import Lottie


class ViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    //lottieアニメーションファイルをJSON形式でダウンロードし、ファイル名をリストで記載
    var onboardArray = ["runu-1","runu-2","runu-3","runu-4","runu-5"]
    
    //チュートリアルで表示させるテキストをリストで記載
    var onboardStringArray = ["RUN Uへようこそ！",
                              "あなたのRUNで社会に貢献しましょう",
                              "あなたはスマホを持って走るだけ",
                              "走った距離に応じてポイントが付きます",
                              "さぁ　はじめよう！",]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.isPagingEnabled = true
        setUpScroll()
        
        for i in 0...4 {
            let animationView = AnimationView()
            let animation = Animation.named(onboardArray[i])
            animationView.frame = CGRect(x: CGFloat(i)*view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            animationView.animation = animation
            //画像配置をコードで指定
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            scrollView.addSubview(animationView)
        }
        
    }
    
    
    //viewdidloadに記載する内容を関数で持たせる
    func setUpScroll(){
        //UIScrollViewdeledateのdelegate先を記載
        scrollView?.delegate = self
        scrollView?.contentSize = CGSize(width: view.frame.size.width * 5, height: scrollView.frame.size.height)
        for i in 0...4 {
            let onboardLabel = UILabel(frame: CGRect(x: CGFloat(i)*view.frame.size.width, y: view.frame.size.height/3, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            onboardLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
            onboardLabel.textAlignment = .center
            onboardLabel.text = onboardStringArray[i]
            scrollView.addSubview(onboardLabel)
            }
    }


}

