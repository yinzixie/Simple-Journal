//
//  WeatherCollectionPage.swift
//  SimpleJournal
//
//  Created by yinzixie on 24/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

protocol PassWeatherDate {
    func passWeather(weather:String)
}

class WeatherCollectionPage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var passWeatherDate: PassWeatherDate?
    var ChoosenWeather: String = "WeatherNone"
    
    let Weathers = WeatherList.Weathers
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionCell", for: indexPath) as! WeatherCollectionCell
        
        // Configure the cell...
        if let WeatherCell = cell as? WeatherCollectionCell
        {
            WeatherCell.WeatherLabel.text = Weathers[indexPath.item]
            WeatherCell.WeatherImageView.image =  UIImage(named: Weathers[indexPath.item])
            WeatherCell.layer.cornerRadius = 5
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.backgroundColor = UIColor.gray.cgColor
        
        self.ChoosenWeather = Weathers[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
        cell?.layer.backgroundColor = UIColor.white.cgColor
    
    }
    @IBAction func saveAndBack(_ sender: Any) {
        passWeatherDate?.passWeather(weather:self.ChoosenWeather)
        self.dismiss(animated: true, completion: nil)
    }

}
