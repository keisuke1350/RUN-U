//
//  YoutubeBaseViewController.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/10/03.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit
import SegementSlide

class YoutubeBaseViewController: SegementSlideDefaultViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        defaultSelectedIndex = 0

        // Do any additional setup after loading the view.
    }
    
    override func segementSlideHeaderView() -> UIView {
        let headerView = UIImageView()
        headerView.isUserInteractionEnabled = true
        headerView.contentMode = .scaleAspectFill
        headerView.image = UIImage(named: "header2")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let headerHeight: CGFloat
        if #available(iOS 11.0, *) {
            headerHeight = view.bounds.height/4+view.safeAreaInsets.top
            
        } else {
            headerHeight = view.bounds.height/4+topLayoutGuide.length
        }
        
        headerView.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
        
        return headerView
    }
    
    override var titlesInSwitcher: [String] {
        return ["ランニング","SDGs"]
    }
    
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        switch index {
            
        case 0:
            return YPage1ViewController()
        case 1:
            return YPage2ViewController()
        default:
            return YPage1ViewController()
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
