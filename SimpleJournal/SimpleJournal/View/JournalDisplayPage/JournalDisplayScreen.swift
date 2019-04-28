//
//  JournalDisplayScreen.swift
//  SimpleJournal
//
//  Created by yinzixie on 25/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class JournalDisplayScreen: UIViewController {
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    var journal:Journal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get pics for journal
        let PicsIDList = database.selectPicsByJournal(journal: journal)
        journal.PicsList = Tools.getUIImageList(picList:PicsIDList)
        
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

extension JournalDisplayScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        #warning("记得修改这里 table的元素数量")
        return 7 + journal.PicsList.count
    }
    
    //configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:Any? = nil
        //title
        if (indexPath.row == 0) {
            print("Initial journal details")
            cell = tableView.dequeueReusableCell(withIdentifier: "DisplayTitleCell", for: indexPath) as! DisplayTitleCell
            
            // Configure the cell...
            if let DisplayTitleCell = cell as? DisplayTitleCell
            {
               DisplayTitleCell.TitleLabel.text = journal.Title
            }
        }
            
        //Date
        else if(indexPath.row == 1) {
            cell = tableView.dequeueReusableCell(withIdentifier: "DisplayDateCell", for: indexPath) as! DisplayDateCell
            
            // Configure the cell...
            if let DisplayDateCell = cell as? DisplayDateCell
            {
                DisplayDateCell.DateLabel.text = journal.DateString
            }
        }
            
        //Location
        else if (indexPath.row == 2) {
            cell = tableView.dequeueReusableCell(withIdentifier: "DisplayLocationCell", for: indexPath) as! DisplayLocationCell
            
            // Configure the cell...
            if let DisplayLocationCell = cell as? DisplayLocationCell
            {
                DisplayLocationCell.LocationLabel.text = journal.Location
            }
        }
            
        //Mood
        else if(indexPath.row == 3) {
            cell = tableView.dequeueReusableCell(withIdentifier: "DisplayMoodCell", for: indexPath) as! DisplayMoodCell
            
            // Configure the cell...
            if let DisplayMoodCell = cell as? DisplayMoodCell
            {
                DisplayMoodCell.MoodImageView.image = UIImage(contentsOfFile: AppFile.getMoodImageFullPath(imageName: journal.Mood))
            }
        }
            
        //Weather
        else if(indexPath.row == 4) {
            cell = tableView.dequeueReusableCell(withIdentifier: "DisplayWeatherCell", for: indexPath) as! DisplayWeatherCell
            
            // Configure the cell...
            if let DisplayWeatherCell = cell as? DisplayWeatherCell
            {
                DisplayWeatherCell.WeatherImageView.image = UIImage(named:journal.Weather)
            }
        }
            
        //Text
        else if(indexPath.row == 5) {
            cell = tableView.dequeueReusableCell(withIdentifier: "DisplayTextCell", for: indexPath) as! DisplayTextCell
            
            // Configure the cell...
            if let DisplayTextCell = cell as? DisplayTextCell
            {
                    DisplayTextCell.TextView.text = journal.TextContent
            }
        }
            
        //Recording
        else if(indexPath.row == 6) {
            cell = tableView.dequeueReusableCell(withIdentifier: "DisplayRecordingCell", for: indexPath) as! DisplayRecordingCell
            
            // Configure the cell...
          //  if let RecordingCell = cell as? RecordingCell
           // {
               
           // }
        }
        //pics
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "DisplayPicCell", for: indexPath) as! DisplayPicCell
            
            // Configure the cell...
            if let DisplayPicCell = cell as? DisplayPicCell
            {
                #warning("用户可以点开图片看大图")
               // let TapController = UITapGestureRecognizer(target: self, action: #selector(pickImages))
                //DisplayPicCell.ImageView.addGestureRecognizer(TapController)
                DisplayPicCell.ImageView.isUserInteractionEnabled = true
                DisplayPicCell.ImageView.tag = indexPath.row
                
                let EedgeNum = Int(indexPath.row) - 7
                
                if(journal.PicsList.count > 0 && EedgeNum < journal.PicsList.count) {
                    DisplayPicCell.ImageView.image = journal.PicsList[indexPath.row - 7]
                }
            }
        }
        
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
   
    
}
