//
//  SettingScreenViewController.swift
//  SimpleJournal
//
//  Created by yinzixie on 18/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class SettingScreen: UIViewController {
    @IBOutlet var ShowPicPickerChooseButton: UIButton!
    @IBOutlet var ImagePickerButton: UIButton!
    @IBOutlet var HeadPhoto: UIImageView!
    
    //变暗
    var transparentView = UIView()
    //picker pic table
    var pickImageTableView = UITableView()
    
    var imagePicker:UIImagePickerController?
    
    let PickImageMenuTextArray = ["Take photo","Choose from album"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHeadPhoto()
        
        pickImageTableView.isScrollEnabled = false
        pickImageTableView.delegate = self
        pickImageTableView.dataSource = self
        pickImageTableView.register(PickImageMenueCell.self, forCellReuseIdentifier: "cell")
        
   //  ImagePickerButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
   //
   //  imagePicker = UIImagePickerController()
   //  imagePicker?.allowsEditing = true
   //  imagePicker?.sourceType = .photoLibrary
   //  imagePicker?.delegate = self
        // Do any additional setup after loading the view.
        
       // let ImagePickerButtonVerticalConstraint = NSLayoutConstraint(item: ImagePickerButton, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 812/screenh*100) //812 iphone x height //set top alignment
    
        
       // view.addConstraints([ImagePickerButtonVerticalConstraint])
    }
    
    private func setHeadPhoto() {
        HeadPhoto?.image = UIImage(named:"2")?.toCircle()
        
        HeadPhoto?.layer.cornerRadius = HeadPhoto.frame.width/2
        HeadPhoto?.clipsToBounds = true
        
    }
    
    
    @IBAction func BackToTabView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

 /*   @IBAction func ShowPicPickerMenu(_ sender: Any) {
        let window = UIApplication.shared.keyWindow
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        transparentView.frame = self.view.frame
        //self.view.addSubview(transparentView) //this can't include navigation bar and tabbar so we user follwing one
        window?.addSubview(transparentView)
        
        self.transparentView.alpha = CGFloat(0)
        
        pickImageTableView.frame = CGRect(x: 0, y:screen.screenh, width: screen.screenw, height: 100)
        window?.addSubview(pickImageTableView)
        
        let pickerGesture = UITapGestureRecognizer(target: self, action: #selector(clickTransparentView))
        transparentView.addGestureRecognizer(pickerGesture)
        
        //animation for 屏幕变暗
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { self.transparentView.alpha = CGFloat(0.5)
            self.pickImageTableView.frame = CGRect(x:0,y:(screen.screenh - 100), width: screen.screenw, height: 100)
        }, completion: nil)
        
    }
    
    //open image
 /*   @objc func openImagePicker(_ sender:Any) {
        self.present(imagePicker!, animated: true, completion: nil)
        
    }*/
    
    @objc func clickTransparentView() {
        //animation for 屏幕变暗
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { self.transparentView.alpha = CGFloat(0)
            self.pickImageTableView.frame = CGRect(x:0,y:screen.screenh, width: screen.screenw, height: 0)
        }, completion: nil)
        
        //transparentView.alpha = 0
    }*/

}

extension SettingScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var journal = journas[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PickImageMenueCell else{
            fatalError("Can't deque cell for pick image menu")
            
        }
        
        if let MenuCell = cell as? PickImageMenueCell
        {
            MenuCell.Label.text = PickImageMenuTextArray[indexPath.row]
            MenuCell.Label.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            
        }else if(indexPath.row == 1) {
            
        }
    }
    
}

extension HomeScreen:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.HeadPhoto.image = pickImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
