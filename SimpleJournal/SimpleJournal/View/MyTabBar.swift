//
//  MyTabBar.swift
//  SimpleJournal
//
//  Created by yinzixie on 14/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class MyTabBar: UITabBarController {


    @IBOutlet var MytabBar: UITabBar!
    
    let CreateButton = UIButton.init(type: .custom)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CreateButton.setTitle("New", for:.normal)
        CreateButton.setTitleColor(.black, for: .normal)
        CreateButton.setTitleColor(.red, for: .highlighted)
        //CreateButton.frame = CGRect(x:100, y:0, width: 44, height: 44)
        CreateButton.backgroundColor = .blue
        CreateButton.layer.borderWidth = 4
        CreateButton.layer.borderColor = UIColor.red.cgColor
        self.view.insertSubview(CreateButton, aboveSubview: self.tabBar)
        
        //disable centre tabbar item
        if let arrayOfTabBarItems = self.tabBar.items as AnyObject as? NSArray,let
            tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
            tabBarItem.isEnabled = false
        }
     
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe place to set the frame of button manually
        CreateButton.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 104, width: 64, height: 64)
        CreateButton.layer.cornerRadius = 32
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
