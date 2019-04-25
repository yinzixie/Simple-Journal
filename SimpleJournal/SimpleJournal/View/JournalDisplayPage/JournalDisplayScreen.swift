//
//  JournalDisplayScreen.swift
//  SimpleJournal
//
//  Created by yinzixie on 25/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class JournalDisplayScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backToPreviousPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
