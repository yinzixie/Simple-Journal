//
//  CreateNewJournalScreenViewController.swift
//  SimpleJournal
//
//  Created by yinzixie on 16/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit
import Photos



class CreateNewJournalScreen: UIViewController, PassDateData, PassMoodData, PassWeatherDate, PassLocationData {
   
    
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    
    var imagePicker = UIImagePickerController()
    
    var journal: Journal!
    
    var editingText = false
    
    private var PicsIDList: [String]?
    private var DeletePicsIDList = [String]()
    private var AddPicsImageList = [UIImage]()
    
    public var EditMode:String!
    
    private let ButtonRadius = 25 //button 半径
   
    private let ButtonX = Int(screen.screenw) - (50) - 10
    private let ButtonY = Int(screen.screenh) - 80
    
    private let OffSet = 90 //相对位置
    private let SqrtOffSet = Int(sqrt(90*90/2))
    
    private var AddPicButtonCenter:CGPoint!
    private var AddRecordingButtonCenter:CGPoint!
    private var AddVideosButtonCenter:CGPoint!
    
    @IBOutlet var TableView: UITableView!
    
    @IBOutlet var SaveButton: UIButton!
    
    
    let MenuButton = UIButton.init(type: .custom)
    let AddPicsButton = UIButton.init(type: .custom)
    let AddRecordingButton = UIButton.init(type: .custom)
    let AddVideosButton = UIButton.init(type: .custom)
    
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        // Do any additional setup after loading the view.
        print("Initial Create/Edit Screen")
        setMenuButtons()
        if(EditMode == "Edit") {
            PicsIDList = database.selectPicsByJournal(journal: journal)
            journal.PicsList = Tools.getUIImageList(picList:PicsIDList!)
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard_))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        //strat listenning keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChanged), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChanged), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func dismissKeyboard_() {
        view.endEditing(true)
    }
    
    @objc func keyBoardWillChanged(notification: Notification) {
        print("Key board will show:\(notification.name.rawValue)")
        
        guard let keyBoardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if((notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification) && editingText) {
            view.frame.origin.y = -keyBoardRect.height
        }else {
            view.frame.origin.y = 0
            editingText = false
        }
    }
    
    
    
    //remove notification stop listenning key board
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //create center button(create a new journal) and add animation
    private func setMenuButtons() {
        //set background color
        MenuButton.backgroundColor = .orange
        //AddPicsButton.backgroundColor = .yellow
       // AddRecordingButton.backgroundColor = .blue
        //AddVideosButton.backgroundColor = .red
        
    
        //set image
        MenuButton.setImage(UIImage(named:"MoreMenu"), for:.normal)
        AddPicsButton.setImage(UIImage(named:"Picture"), for:.normal)
        AddRecordingButton.setImage(UIImage(named:"Question"), for:.normal)
        AddVideosButton.setImage(UIImage(named:"Camera"), for:.normal)
        
        //set trigger event
        MenuButton.addTarget(self, action: #selector(self.showMoreButton), for: .touchUpInside)
        AddPicsButton.addTarget(self, action: #selector(self.showPicsPicker), for: .touchUpInside)
        AddVideosButton.addTarget(self, action: #selector(self.showCamera), for: .touchUpInside)
        
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
        

        //add button to screen
        self.view.insertSubview(MenuButton, aboveSubview: self.TableView)
        self.view.insertSubview(AddPicsButton, aboveSubview: self.TableView)
        self.view.insertSubview(AddRecordingButton, aboveSubview: self.TableView)
        self.view.insertSubview(AddVideosButton, aboveSubview: self.TableView)
    }
    
    //animation for more menu
    @objc func showMoreButton(_ sender:UIButton) {
        
        if (sender.currentImage == UIImage(named:"MoreMenu")) {
            UIView.animate(withDuration: 0.3, animations: {
                self.AddPicsButton.center = self.AddPicButtonCenter
                self.AddRecordingButton.center = self.AddRecordingButtonCenter
                self.AddVideosButton.center = self.AddVideosButtonCenter
            })
            
            sender.backgroundColor = .lightGray
            sender.setImage(UIImage(named:"CloseMoreMenu"), for: .normal)
        }else {
            UIView.animate(withDuration: 0.3, animations: {
                self.AddPicsButton.center = self.MenuButton.center
                self.AddRecordingButton.center = self.MenuButton.center
                self.AddVideosButton.center = self.MenuButton.center
            })
            sender.backgroundColor = .orange
            sender.setImage(UIImage(named:"MoreMenu"), for: .normal)
        }
    }
    
    //show pics picker
    @objc func showPicsPicker(_ sender:UIButton) {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            imagePicker.sourceType = .photoLibrary
            // 打开图片选择器
            present(imagePicker, animated: true, completion: nil)
        }else {
            #warning("如何显示具体的类型， 并弹出警告框")
            print("Can't access ",imagePicker.sourceType)
        }
    }
    
    //show pics picker
    @objc func showCamera(_ sender:UIButton) {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imagePicker.sourceType = .camera
            // 打开图片选择器
            present(imagePicker, animated: true, completion: nil)
        }else {
            #warning("如何显示具体的类型， 并弹出警告框")
            print("Can't access ",imagePicker.sourceType)
        }
    }
    

    @IBAction func BackToTabView(_ sender: Any) {
        
        #warning("弹出确认窗口")
        JournalListCache.refresh()
        self.dismiss(animated: true, completion: nil)
       
        //jump to admin page through segue"BackToTabView"
       // self.performSegue(withIdentifier:"BackToTabView", sender: self)
    }
   
    func passMood(mood:String) {
        print(mood)
        journal.Mood = mood
         //update table
        let indexpath = IndexPath.init(row: 3,section: 0)
        self.TableView.beginUpdates()
        self.TableView.reloadRows(at: [indexpath], with: .automatic)
        self.TableView.endUpdates()
    }
    
    func passDate(date: Date) {
        print(date)
        journal.setDateAndRelevantData(date:date)
    }
    
    func passWeather(weather: String) {
        print(weather)
        journal.Weather = weather
        //update table
        let indexpath = IndexPath.init(row: 4,section: 0)
        self.TableView.beginUpdates()
        self.TableView.reloadRows(at: [indexpath], with: .automatic)
        self.TableView.endUpdates()
    }
    
    func passLocationString(location: String) {
        print(location)
        journal.Location = location
        let indexPath = IndexPath(row: 2, section: 0)
        TableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showMoodCollectionSegue") {
            let vc = segue.destination as! MoodCollectionPage
            vc.passMoodData = self
        }else if (segue.identifier == "showWeatherCollectionSegue") {
            let vc = segue.destination as! WeatherCollectionPage
            vc.passWeatherDate = self
        }else if(segue.identifier == "showMapViewSegue") {
            let vc = segue.destination as! MapScreen
            vc.passLocationData = self
        }
    }
    
    @IBAction func saveJournal(_ sender: Any) {
        #warning("title 检测有问题，如果不点击别的 地方无法保存")
        
        if(journal.PicsList.count > 0) {
            journal.DisplayPic = journal.PicsList[0].accessibilityIdentifier
        }
        
        if(EditMode == "Create") {
            
            if(database.insertJournal(journal: journal)) {

                database.insertPic(journal:journal)
               
                JournalListCache.refresh()
                
                self.dismiss(animated: true, completion: nil)
                #warning("弹出窗口提示")
            }
            else {
                #warning("弹出窗口")
                print("error!can't create journal")
            }
        }else if(EditMode == "Edit"){
            
            if(database.updateJournal(journal: journal)){
                database.insertPicByImageList(journal: journal,list:AddPicsImageList)
                database.deletePicsByStringList(journal:journal,pics:DeletePicsIDList)
            }
            
            JournalListCache.refresh()
            self.dismiss(animated: true, completion: nil)
            #warning("弹出窗口提示")
        }
    }
}

extension CreateNewJournalScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        #warning("记得修改这里 table的元素数量")
        return 7 + journal.PicsList.count
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
                
                TitleCell.TitleTextField.addTarget(self, action: #selector(titleTextFieldDidChange), for: UIControl.Event.editingChanged)
                //TitleCell.TitleTextField.delegate = self //针对下面等扩展，监听输入
                TitleCell.ParentView = self
                TitleCell.TitleTextField.tag = 0
                
                if(EditMode == "Edit") {
                    TitleCell.TitleTextField.text = journal.Title
                }
            }
        }
            
        //Date
        else if(indexPath.row == 1) {
            cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
            
            // Configure the cell...
            if let DateCell = cell as? DateCell
            {
                DateCell.ParentView = self
                DateCell.passDate = self
                DateCell.DateTextField.text = DateInfo.dateToDateString(Date(), dateFormat: "yyyy-MM-dd  HH:mm:ss")
               // DateCell.isUserInteractionEnabled = false
                
                if(EditMode == "Edit") {
                   DateCell.DateTextField.text = journal.DateString
                }
            }
        }
            
        //Location
        else if (indexPath.row == 2) {
            cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            
            // Configure the cell...
            if let LocationCell = cell as? LocationCell
            {
                LocationCell.ParentView = self
                LocationCell.LocationTextField.addTarget(self, action: #selector(locationTextFieldDidChange), for: UIControl.Event.editingChanged)
                //LocationCell.LocationTextField.delegate = self //针对下面等扩展，监听输入
                LocationCell.LocationTextField.tag = 2
               // LocationCell.isUserInteractionEnabled = false
                
                if(journal.Location != "LocationNone") {
                    LocationCell.LocationTextField.text = journal.Location
                }
            }
        }
        
        //Mood
        else if(indexPath.row == 3) {
            cell = tableView.dequeueReusableCell(withIdentifier: "MoodCell", for: indexPath) as! MoodCell
            
            // Configure the cell...
            if let MoodCell = cell as? MoodCell
            {
                MoodCell.ParentView = self
                
                if(journal.Mood != "MoodNone") {
                MoodCell.MoodImageView.image = UIImage(contentsOfFile:AppFile.getMoodImageFullPath(imageName: journal.Mood))
                //MoodCell.isUserInteractionEnabled = false
                }
            }
            
        }
        //Weather
        else if(indexPath.row == 4) {
            cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
            
            // Configure the cell...
            if let WeatherCell = cell as? WeatherCell
            {
                WeatherCell.ParentView = self
                WeatherCell.WeatherImageView.image = UIImage(named:journal.Weather)
                //WeatherCell.isUserInteractionEnabled = false
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
              
                if(EditMode == "Edit") {
                    TextCell.TextDisplayField.text = journal.TextContent
                }
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
                
                let EedgeNum = Int(indexPath.row) - 7
               
                if(journal.PicsList.count > 0 && EedgeNum < journal.PicsList.count) {
                    PicsCell.ImageView.image = journal.PicsList[indexPath.row - 7]
                }
            }
        }
        
        return cell as! UITableViewCell
    }
   
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row <= 6) {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            DeletePicsIDList += [(journal.PicsList[indexPath.row - 7]).accessibilityIdentifier!]
            
            journal.PicsList.remove(at: indexPath.row - 7)
            self.TableView.beginUpdates()
            self.TableView.deleteRows(at: [indexPath], with: .automatic)
            self.TableView.endUpdates()
        }
    }
    
    @objc func titleTextFieldDidChange(textField: UITextField) {
        journal.Title = textField.text
    }
    
    @objc func locationTextFieldDidChange(textField: UITextField) {
        journal.Location = textField.text
    }
    
    @objc func pickImages() {
       
    }
    
    @objc func startRecording() {
        print("func")
        
    }
    
}

extension CreateNewJournalScreen: UITextViewDelegate{
    //textview每次内容变化时，调用tableView的刷新方法
    func textViewDidChange(_ textView: UITextView) {
        TableView.beginUpdates()
        TableView.endUpdates()
        journal.TextContent = textView.text
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        editingText = true
        return true
    }
}

extension CreateNewJournalScreen: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

/*extension CreateNewJournalScreen: UITextFieldDelegate{
    //每次内容变化时返回title location
    func textFieldDidEndEditing(_ textField: UITextField) {
        //title
        if (textField.tag == 0) {
            journal.Title = textField.text
        }
        //location
        else if (textField.tag == 2) {
            journal.Location = textField.text
        }
    }
}*/



extension CreateNewJournalScreen:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("test")
            pickImage.accessibilityIdentifier = journal.PicsTableID! + "_" + DateInfo.dateToDateString(Date(), dateFormat: "yyyyMMdd_HH:mm:ss")
            
            AddPicsImageList += [pickImage]
            
            journal.PicsList.append(pickImage)
            
            let indexPath = IndexPath(row:journal.PicsList.count + 7 - 1, section: 0 )
            
            self.TableView.beginUpdates()
            self.TableView.insertRows(at: [indexPath], with: .automatic)
            self.TableView.endUpdates()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

}




