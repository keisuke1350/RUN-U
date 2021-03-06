//
//  EventDetailViewController.swift
//  RUNU
//
//  Created by 葛西　佳祐 on 2020/09/27.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    var selectedEvent = EventModel()
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.eventTitle?.text = "\(selectedEvent.title)"
        detailTextView.text = selectedEvent.memo
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
