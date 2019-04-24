//
//  WeatherCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 21/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    var ParentView:UIViewController? = nil
    @IBOutlet var WeatherImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func goToWeatherCollectionView(_ sender: Any) {
        //jump to admin page through segue"showWeatherCollectionView"
        ParentView?.performSegue(withIdentifier:"showWeatherCollectionSegue", sender: self)
    }
}
