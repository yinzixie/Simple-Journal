//
//  HomeScreen.swift
//  SimpleJournal
//
//  Created by yinzixie on 14/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//
import Foundation
import UIKit

class HomeScreen: UIViewController {

    @IBOutlet var HeadPhoto: UIImageView!
    @IBOutlet var UserName: UILabel!
    
    @IBOutlet var ShowPicPickerChooseButton: UIButton!
    @IBOutlet var ImagePickerButton: UIButton!
    
    let screenh = UIScreen.main.bounds.size.height
    let screenw = UIScreen.main.bounds.size.width
    
    //变暗
    var transparentView = UIView()
    //picker pic table
    var pickTableView = UITableView()
    
    var imagePicker:UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view.
        
        setHeadPhoto()
        
        //HeadPhoto.translatesAutoresizingMaskIntoConstraints = false //some say we should add this to disable auto layout but we don't need this here
        
        let ImagePickerButtonVerticalConstraint = NSLayoutConstraint(item: ImagePickerButton, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 812/screenh*100) //812 iphone x height //set top alignment
       
         let verticalConstraint = NSLayoutConstraint(item: HeadPhoto, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 812/screenh*100) //812 iphone x height //set top alignment
        
        view.addConstraints([verticalConstraint,ImagePickerButtonVerticalConstraint])
        
        //hidden the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        
        
        
        
        ImagePickerButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker?.allowsEditing = true
        imagePicker?.sourceType = .photoLibrary
        imagePicker?.delegate = self
        
        
        
        
    }

    
    //same as the top one
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }*/
    
    //open image
    @objc func openImagePicker(_ sender:Any) {
        self.present(imagePicker!, animated: true, completion: nil)
        
    }
    
    
    private func setHeadPhoto() {
        HeadPhoto?.image = UIImage(named:"2")?.toCircle()
        
        HeadPhoto?.layer.cornerRadius = HeadPhoto.frame.width/2
        HeadPhoto?.clipsToBounds = true
        
       // HeadPhoto?.layer.borderWidth = 2
       // HeadPhoto?.layer.borderColor = UIColor.blue.cgColor
        
        
        /*HeadPhoto.layer.borderWidth = 1
         HeadPhoto.layer.masksToBounds = false
         HeadPhoto.layer.borderColor = UIColor.black.cgColor
         HeadPhoto.layer.cornerRadius = HeadPhoto.frame.height/2
         HeadPhoto.clipsToBounds = true*/
    }
   
    @IBAction func ShowPicPickerMenu(_ sender: Any) {
        let window = UIApplication.shared.keyWindow
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        transparentView.frame = self.view.frame
        //self.view.addSubview(transparentView) //this can't include navigation bar and tabbar so we user follwing one
        window?.addSubview(transparentView)
        self.transparentView.alpha = CGFloat(0)
        
        pickTableView.frame = CGRect(x: 0, y: screenh, width: screenw, height: 150)
        window?.addSubview(pickTableView)
        
        let pickerGesture = UITapGestureRecognizer(target: self, action: #selector(clickTransparentView))
        transparentView.addGestureRecognizer(pickerGesture)
        
        //animation for 屏幕变暗
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { self.transparentView.alpha = CGFloat(0.5)
            self.pickTableView.frame = CGRect(x:0,y:self.screenh - 250, width: self.screenw, height: 500)
        }, completion: nil)
        
    }
    
    @objc func clickTransparentView() {
        //animation for 屏幕变暗
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { self.transparentView.alpha = CGFloat(0)
            self.pickTableView.frame = CGRect(x:0,y:self.screenh, width: self.screenw, height: 0)
        }, completion: nil)
        
        //transparentView.alpha = 0
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

/*extension UIImageView {
    
    //crop pic from left cornor
    func cropCornerRadius(radius:CGFloat){
        
        //开始图形上下文
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        //获取图形上下文
        let ctx = UIGraphicsGetCurrentContext()
        //根据一个rect创建一个椭圆
        ctx!.addEllipse(in: self.bounds)
        //裁剪
        ctx!.clip()
        //将原照片画到图形上下文
        self.image!.draw(in: self.bounds)
        //从上下文上获取剪裁后的照片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        
        self.image = newImage
    }
}*/

extension UIImage {
    //生成圆形图片
    func toCircle() -> UIImage {
        //取最短边长
        let shotest = min(self.size.width, self.size.height)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        //绘制图片
        self.draw(in: CGRect(x: (shotest-self.size.width)/2,
                             y: (shotest-self.size.height)/2,
                             width: self.size.width,
                             height: self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
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

extension HomeScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let share = shareAction(at: indexpath)
        
        return UISwipeActionsConfiguration([actions: [share,delete,edit]])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        #warning("记得修改这里 table的元素数量")
        return 1
    }
    
    //configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var journal = journas[indexPath.row]
}
