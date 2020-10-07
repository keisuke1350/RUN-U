//
//  uActionViewController.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/08/23.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit
import Pastel

class uActionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var sdgsCollectionView: UICollectionView!
    @IBOutlet weak var UPoints: UILabel!
    
    private let photos = ["sdgs", "sdgs01", "sdgs02", "sdgs03", "sdgs04", "sdgs05","sdgs06", "sdgs07", "sdgs08", "sdgs09", "sdgs10", "sdgs11", "sdgs12", "sdgs13", "sdgs14", "sdgs15", "sdgs16", "sdgs17"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        view.sendSubviewToBack(pastelView)
        
        view.bringSubviewToFront(sdgsCollectionView)
        
//
        //collectionViewの実装
        sdgsCollectionView.delegate = self
        sdgsCollectionView.dataSource = self
        
        sdgsCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "sdgsCollectionCell1")
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        sdgsCollectionView.collectionViewLayout = layout
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = sdgsCollectionView.dequeueReusableCell(withReuseIdentifier: "sdgsCollectionCell1", for: indexPath)
        let photoImageView = cell.contentView.viewWithTag(1) as! UIButton
        let photoImage = UIImage(named: photos[indexPath.row])
        photoImageView.setImage(photoImage, for: .normal)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
        
        if let buy = UserDefaults.standard.object(forKey: "buy"){
            //何かデータが入っていたら
            let count:Int = buy as! Int
            UPoints.text = String(count)
            
        } else {
            //何もキー値に入っていない場合
            UserDefaults.standard.set(Int(UPoints.text!),forKey: "buy")
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //[indexPath.row]から画像名を探しUIImageを設定
  
        print(indexPath.row)
        if indexPath.row == 11 {
            confirmAlert()
            
        }
        
        
    }
    
    func confirmAlert(){
        let alert: UIAlertController = UIAlertController(title: "確認", message: "120ポイントを消費し、寄付しますか？", preferredStyle: .alert)
        let okAction:UIAlertAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            
            if Int(self.UPoints.text!)! < 120 {
                print("残コインが不足しています")
                
                
            } else {
                var coinCount = Int()
                coinCount = Int(self.UPoints.text!)! - 120
                UserDefaults.standard.set(coinCount, forKey: "buy")
                self.UPoints.text = String(coinCount)
            }
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "また後で", style: .cancel) { (alert) in
            //何もしない
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
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
