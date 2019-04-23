//
//  CreateNewJournalScreenViewController.swift
//  SimpleJournal
//
//  Created by yinzixie on 16/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class CreateNewJournalScreen: UIViewController {

    var pics: [UIImage] = [UIImage(imageLiteralResourceName: "snow")]
    
    private let ButtonRadius = 25
   
    private let ButtonX = Int(screen.screenw) - (50) - 10
    private let ButtonY = Int(screen.screenh) - 80
    
    private let OffSet = 90
    private let SqrtOffSet = Int(sqrt(90*90/2))
    
    private var AddPicButtonCenter:CGPoint!
    private var AddRecordingButtonCenter:CGPoint!
    private var AddVideosButtonCenter:CGPoint!
    
    @IBOutlet var TableView: UITableView!
    
    @IBOutlet var test: UIButton!
    
    
    let MenuButton = UIButton.init(type: .custom)
    let AddPicsButton = UIButton.init(type: .custom)
    let AddRecordingButton = UIButton.init(type: .custom)
    let AddVideosButton = UIButton.init(type: .custom)
    
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe place to set the frame of button manually
        MenuButton.frame = CGRect(x:ButtonX ,y: ButtonY , width: 2*ButtonRadius, height: 2*ButtonRadius)
        MenuButton.layer.cornerRadius = CGFloat(ButtonRadius)
        
        AddPicsButton.frame = CGRect(x:ButtonX,y: ButtonY - OffSet, width: 2*ButtonRadius, height: 2*ButtonRadius)
        AddPicsButton.layer.cornerRadius = CGFloat(ButtonRadius)
        
        AddRecordingButton.frame = CGRect(x:ButtonX - SqrtOffSet,y: ButtonY - SqrtOffSet, width: 2*ButtonRadius, height: 2*ButtonRadius)
        AddRecordingButton.layer.cornerRadius = CGFloat(ButtonRadius)
        
        AddVideosButton.frame = CGRect(x:ButtonX - OffSet,y: ButtonY, width: 2*ButtonRadius, height: 2*ButtonRadius)
        AddVideosButton.layer.cornerRadius = CGFloat(ButtonRadius)
        
        //save original center
        AddPicButtonCenter = AddPicsButton.center
        AddRecordingButtonCenter = AddRecordingButton.center
        AddVideosButtonCenter = AddVideosButton.center
        
        //hide menu
        AddPicsButton.center = MenuButton.center
        AddRecordingButton.center = MenuButton.center
        AddVideosButton.center = MenuButton.center
    }
    
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
        setMenuButtons()
        
        
        
    }
    
    //create center button(create a new journal) and add animation
    private func setMenuButtons() {
        //set background color
        MenuButton.backgroundColor = .orange
        
        
        //set image
        MenuButton.setImage(UIImage(named:"moreMenu"), for:.normal)
        AddPicsButton.setImage(UIImage(named:"tabbar_add_yellow"), for:.normal)
        AddRecordingButton.setImage(UIImage(named:"tabbar_add_yellow"), for:.normal)
        AddVideosButton.setImage(UIImage(named:"tabbar_add_yellow"), for:.normal)
        
        //set trigger event
        MenuButton.addTarget(self, action: #selector(self.showMoreButton), for: .touchUpInside)
        AddPicsButton.addTarget(self, action: #selector(self.showPicsPicker), for: .touchUpInside)
        
        //add button to screen
        self.view.insertSubview(MenuButton, aboveSubview: self.TableView)
        self.view.insertSubview(AddPicsButton, aboveSubview: self.TableView)
        self.view.insertSubview(AddRecordingButton, aboveSubview: self.TableView)
        self.view.insertSubview(AddVideosButton, aboveSubview: self.TableView)
    }
    
    //animation for more menu
    @objc func showMoreButton(_ sender:UIButton) {
        
        if (sender.currentImage == UIImage(named:"moreMenu")) {
            UIView.animate(withDuration: 0.3, animations: {
                self.AddPicsButton.center = self.AddPicButtonCenter
                self.AddRecordingButton.center = self.AddRecordingButtonCenter
                self.AddVideosButton.center = self.AddVideosButtonCenter
            })
            
            sender.backgroundColor = .lightGray
            sender.setImage(UIImage(named:"closeMoreMenu"), for: .normal)
        }else {
            UIView.animate(withDuration: 0.3, animations: {
                self.AddPicsButton.center = self.MenuButton.center
                self.AddRecordingButton.center = self.MenuButton.center
                self.AddVideosButton.center = self.MenuButton.center
            })
            sender.backgroundColor = .orange
            sender.setImage(UIImage(named:"moreMenu"), for: .normal)
        }
    }
    
    //show pics picker
    @objc func showPicsPicker(_ sender:UIButton) {
        let alert = UIAlertController(style: .actionSheet)
        alert.addPhotoLibraryPicker(
            flow: .vertical,
            paging: true,
            selection: .multiple(action: { images in
                // action with selected image
                for image in images{
                    self.pics.append(PHAssetToImage.PHAssetToImage(asset: image)) //append(contentsOf: images)
                    
                    let indexPath = IndexPath(row:self.pics.count + 7 - 1, section: 0 )
                    
                    self.TableView.beginUpdates()
                    self.TableView.insertRows(at: [indexPath], with: .automatic)
                    self.TableView.endUpdates()
                }
                
            }))
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true)
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
        return 8 + pics.count
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
                TextCell.TextDisplayField.delegate = self //针对下面等扩展，监听输入
            }
            
        }
        //Recording
        else if(indexPath.row == 6) {
            cell = tableView.dequeueReusableCell(withIdentifier: "RecordingCell", for: indexPath) as! RecordingCell
            
            // Configure the cell...
            if let RecordingCell = cell as? RecordingCell
            {
                RecordingCell.ParentView = self
                let TapController = UITapGestureRecognizer(target: self, action: #selector(startRecording))
                RecordingCell.ImageView.addGestureRecognizer(TapController)
            }
        }
        //pics
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "PicsCell", for: indexPath) as! PicsCell
            
            // Configure the cell...
            if let PicsCell = cell as? PicsCell
            {
                PicsCell.ParentView = self
                let TapController = UITapGestureRecognizer(target: self, action: #selector(pickImages))
                PicsCell.ImageView.addGestureRecognizer(TapController)
                PicsCell.ImageView.isUserInteractionEnabled = true
                PicsCell.ImageView.tag = indexPath.row
                
                var t = Int(indexPath.row) - 7
                print("now:",indexPath.row)
                print(t)
                if(pics.count > 0 && t < pics.count) {
                    print("pic:",pics.count)
                    PicsCell.ImageView.image = pics[indexPath.row - 7]
                }
            }
        }
        
        return cell as! UITableViewCell
       
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row <= 7) {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pics.remove(at: indexPath.row - 7)
            self.TableView.beginUpdates()
            self.TableView.deleteRows(at: [indexPath], with: .automatic)
            self.TableView.endUpdates()
        }
    }
    
    @objc func pickImages() {
       
    }
    
    @objc func startRecording() {
        print("func")
        
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

