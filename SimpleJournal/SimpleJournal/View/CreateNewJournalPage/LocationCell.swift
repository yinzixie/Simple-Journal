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
    
    @IBOutlet var LocationDisplayButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func locationDisplayButton(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet)
        alert.addLocationPicker { location in
            // action with location
            self.LocationDisplayButton.setTitle(String(location!.address) , for: .normal)
        }
        alert.addAction(title: "Cancel", style: .cancel)
    
      
        ParentView?.present(alert, animated: true)
    }
}
