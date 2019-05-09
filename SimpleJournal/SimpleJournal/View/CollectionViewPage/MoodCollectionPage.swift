//
//  CollectionView.swift
//  SimpleJournal
//
//  Created by yinzixie on 23/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

protocol PassMoodData {
    func passMood(mood:String)
}
protocol PassMoodDataToCell {
    //func passMood(mood:String)
}

class MoodCollectionPage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var passMoodData: PassMoodData?
    var ChoosenMood: String = "MoodNone"
    var imagePicker = UIImagePickerController()
    var newMoodName:String?
    var Moods = MoodList.Moods
    
    @IBOutlet var moodCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: 用于弹出选择的对话框界面
    private var selectorController: UIAlertController {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil)) // 取消按钮
        controller.addAction(UIAlertAction(title: "Take photo", style: .default) { action in
            self.selectorSourceType(type: .camera)
        }) // 拍照选择
        controller.addAction(UIAlertAction(title: "Choose from album", style: .default) { action in
            self.selectorSourceType(type: .photoLibrary)
        }) // 相册选择
        return controller
    }
    
    private func selectorSourceType(type: UIImagePickerController.SourceType) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if (UIImagePickerController.isSourceTypeAvailable(type)) {
            imagePicker.sourceType = type
            // 打开图片选择器
            present(imagePicker, animated: true, completion: nil)
        }else {
            #warning("如何显示具体的类型， 并弹出警告框")
            print("Can't access ",imagePicker.sourceType)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (Moods.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell!
        //add mood button
        if(indexPath.row == Moods.count) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoodCell", for: indexPath) as! AddNewMoodCell
            
            // Configure the cell...
            if let AddMoodCell = cell as? AddNewMoodCell
            {
                AddMoodCell.AddButton.addTarget(self, action: #selector(addNewMood), for: .touchUpInside)
            }
        }else { //mood cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoodCollectionCell", for: indexPath) as! MoodCollectionCell
            
            // Configure the cell...
            if let MoodCell = cell as? MoodCollectionCell
            {
                MoodCell.MoodLabel.text = Moods[indexPath.item]
                MoodCell.MoodImageView.image =  UIImage(contentsOfFile: AppFile.getMoodImageFullPath(imageName: Moods[indexPath.item]))
                MoodCell.layer.cornerRadius = 5
            }
        }
        return cell
    }
    
    @objc func addNewMood(_ sender:UIButton) {
        //pop up text alert, let user type their new mood
        //1. Create the alert controller.
        let addNewMoodAlert = UIAlertController(title: "Add new mood", message: "Type your custom mood name", preferredStyle: .alert)
        
        //2. Add the text field.
        addNewMoodAlert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Attention:can't be empty!"
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        addNewMoodAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak addNewMoodAlert] (action) -> Void in
            //let textField = addNewMoodAlert?.textFields![0] as! UITextField
            //print("Text field: \(textField.text)")
            
            let newMood = addNewMoodAlert?.textFields![0].text?.lowercased()
            if(newMood != "") {
                 //check weather the name is repeated. if no, pop up image picker to choose mood pic
                if (MoodList.isExist(name: newMood!)) {
                    //pop up alert
                    let repeatedAlert = UIAlertController(title: "Warrning", message: "This mood is already existed", preferredStyle: .alert)
                    repeatedAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                        print("Repeated name")
                    }))
                    self.present(repeatedAlert, animated: true, completion: nil)
                    
                }else {
                    self.newMoodName = newMood
                    
                    //1. Create the notification alert, notice user the next step
                    let notificationAlert = UIAlertController(title: "Add new mood", message: "click ok to choose your mood picture", preferredStyle: .alert)
                    notificationAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                        print("User click ok and ready to pick image")
                        
                        self.present(self.selectorController, animated: true, completion: nil)
                        
                    }))
                    self.present(notificationAlert, animated: true, completion: nil)
                }
            }
            }))
            
            //cancel button
            addNewMoodAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("User canceled add new mood action")
            }))
            
            // 4. Present the alert.
            self.present(addNewMoodAlert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.backgroundColor = UIColor.gray.cgColor
        
        self.ChoosenMood = Moods[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
        cell?.layer.backgroundColor = UIColor.white.cgColor
        //cell?.layer.borderColor = UIColor.lightGray.cgColor
    }
    @IBAction func saveAndBack(_ sender: Any) {
        passMoodData?.passMood(mood:ChoosenMood)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancle(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension MoodCollectionPage:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            //save new mood and exit
            AppFile.saveMoodPhoto(image: pickImage, imageName: self.newMoodName!)
            //refresh mood list
            MoodList.UpdateMoods()
            Moods = MoodList.Moods
            //refresh collection view
            moodCollectionView.reloadData()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
