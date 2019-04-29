//
//  LocationCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 21/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    var ParentView:UIViewController? = nil
    
    @IBOutlet var LocationTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func locationDisplayButton(_ sender: Any) {
        //jump segue"showMapViewSegue"
        ParentView?.performSegue(withIdentifier:"showMapViewSegue", sender: self)
    }
       
}
