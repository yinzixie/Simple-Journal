//
//  CreateNewJournalScreenViewController.swift
//  SimpleJournal
//
//  Created by yinzixie on 16/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class CreateNewJournalScreen: UIViewController {

    
    @IBOutlet var TableView: UITableView!
    
    @IBOutlet var test: UIButton!
    
    
    @IBAction func ttt(_ sender: Any) {
      
        let alert = UIAlertController(style: .actionSheet)
        alert.addLocationPicker { location in
            // action with location
        }
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true)
     /*   let alertDate = UIAlertController(style: .actionSheet, title: "Select date")
        alertDate.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { date in
            // action with selected date
        
        }
        alertDate.addAction(title: "OK", style: .cancel)
        
       
        self.present(alertDate, animated: true)
        
        let alertTime = UIAlertController(style: .actionSheet, title: "Select time")
        alertTime.addDatePicker(mode: .time, date: Date(), minimumDate: nil, maximumDate: nil) { date in
            // action with selected date
        }
        alertTime.addAction(title: "OK", style: .cancel)
        self.present(alertTime, animated: true)*/
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // TabelView.rowHeight = UITableView.automaticDimension
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

extension CreateNewJournalScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        #warning("记得修改这里 table的元素数量")
        return 6
    }
    
    //configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:Any? = nil
        //title
        if (indexPath.row == 0) {
             cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
        
            // Configure the cell...
            if let TitleCell = cell as? TitleCell
            {
                TitleCell.ParentView = self
                TitleCell.TitleDisplayButton.setTitle("Journal Title", for: .normal)
            }
            
        }
        //Location
        else if (indexPath.row == 1) {
            cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            
            // Configure the cell...
            if let LocationCell = cell as? LocationCell
            {
                LocationCell.ParentView = self
                LocationCell.LocationDisplayButton.setTitle("Earth", for: .normal)
            }
        }
        //Date
        else if(indexPath.row == 2) {
            cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
            
            // Configure the cell...
            if let DateCell = cell as? DateCell
            {
                DateCell.ParentView = self
                DateCell.YearDisplayButton.setTitle(String(DateInfo.currentYear()), for: .normal)
                DateCell.DateDisplayButton.setTitle(DateInfo.dateToDateString(Date(), dateFormat: "MM-dd hh:mm:ss"), for: .normal)
            }
        }
        //Moode
        else if(indexPath.row == 3) {
            cell = tableView.dequeueReusableCell(withIdentifier: "MoodCell", for: indexPath) as! MoodCell
            
            // Configure the cell...
            if let MoodCell = cell as? MoodCell
            {
               
            }
            
        }
        //Weather
        else if(indexPath.row == 4) {
            cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
            
            // Configure the cell...
            if let WeatherCell = cell as? WeatherCell
            {
                
            }
            
        }
        //Text
        else if(indexPath.row == 5) {
            cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            
            // Configure the cell...
            if let TextCell = cell as? TextCell
            {
                TextCell.ParentView = self
                TextCell.TextDisplayField.delegate = self
                //TextCell.height = 1000
                print(TextCell.TextDisplayField.height)
            }
            
        }
        //Recording
        else if(indexPath.row == 6) {
            
        }
        //pics
        else if(indexPath.row == 6) {
            
        }
        
        return cell as! UITableViewCell
       
    }
    
}

extension CreateNewJournalScreen: UITextViewDelegate{
    
    //每次内容变化时，调用tableView的刷新方法
    func textViewDidChange(_ textView: UITextView) {
        //print("textViewDidChange")
        TableView.beginUpdates()
        TableView.endUpdates()
    }
}

