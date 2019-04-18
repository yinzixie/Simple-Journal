//
//  CreateNewJournalScreenViewController.swift
//  SimpleJournal
//
//  Created by yinzixie on 16/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class CreateNewJournalScreenViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func BackToTabView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        //jump to admin page through segue"BackToTabView"
       // self.performSegue(withIdentifier:"BackToTabView", sender: self)
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
