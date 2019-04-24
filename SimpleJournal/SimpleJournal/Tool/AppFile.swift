//
//  AppFile.swift
//  SimpleJournal
//
//  Created by yinzixie on 21/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import Foundation
import UIKit

class AppFile {
    // 获得沙盒的根路径
    static let Home = NSHomeDirectory() as NSString;
    
    // 防止Documen文件夹不存在*****************************************************************
    static let Documents = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
    // 获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
    //let docPath = home.stringByAppendingPathComponent("Documents") as NSString;
    
    
    
    //user info folder
    static let UserInfoFolder = "UserInfoFolder"
    static let UserInfoFolderFullPath = Documents.appendingPathComponent(UserInfoFolder) as NSString;
    
    //images folder
    static let ImagesFolder = "ImagesFolder"
    static let ImagesFolderFullPath = Documents.appendingPathComponent(ImagesFolder) as NSString;
    
    //videos folder
    static let VideosFolder = "VideosFolder"
    static let VideosFolderFullPath = Documents.appendingPathComponent(VideosFolder) as NSString;
    
    //recording folder
    static let RecordingsFolder = "RecordingsFolder"
    static let RecordingsFolderFullPath = Documents.appendingPathComponent(RecordingsFolder) as NSString;
    
    //headphoto
    static let HeadPhoto = "HeadPhoto"
    static let HeadPhotoFullPath = UserInfoFolderFullPath.appendingPathComponent(HeadPhoto) as NSString;
    
    
    static let FolderArray = [UserInfoFolderFullPath,ImagesFolderFullPath,VideosFolderFullPath,RecordingsFolderFullPath]
    
    init() {
        for folder in AppFile.FolderArray {
            if (!AppFile.isJudgeFileOrFolderExists(folderName: folder as String)) {
                if(!AppFile.createDir(dir: folder as String)) {
                    #warning("exit app")
                    print("can't create file")
                }
            }
        }
    }
    
    //获得NSFileManager
    class func getFileManager()->FileManager{
        return FileManager.default
    }
    
    //保存图片至沙盒 1heighest-100lowest
    private func saveImage(currentImage: UIImage, persent: CGFloat, imageName: String){
        if let imageData = currentImage.jpegData(compressionQuality:persent) as NSData? {
            let fullPath = NSHomeDirectory().appending("/Documents/").appending(imageName)
            imageData.write(toFile: fullPath, atomically: true)
            print("fullPath=\(fullPath)")
        }
    }
    
    class func saveHeadPhoto(image:UIImage) {
        if let imageData = image.jpegData(compressionQuality:1) as NSData? {
            let fullPath = HeadPhotoFullPath
            imageData.write(toFile: fullPath as String, atomically: true)
            //print("fullPath=\(fullPath)")
        }
    }
    
    //获取Document路径
    class func getDocumentPath() -> String{
        let filePaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return filePaths.first!+"/"
    }
    
    
    //获取文件夹下文件列表
    class func getFileListInFolderWithPath(path:String) -> Array<String>{
        let fileManager = FileManager.default
        let fileList = try! fileManager.contentsOfDirectory(atPath: path)
        return fileList
    }
    
    //获取Documents目录下的所有文件
    class func getDomcumentAllFolder() ->Array<String>{
        let paths = self.getDocumentPath()
        let fileManager = FileManager.default
        let fileList = try! fileManager.contentsOfDirectory(atPath: paths)
        var isDir:ObjCBool = false
        var dirArray = Array<String>()
        for fileName in fileList {
            let path = paths+fileName
            if fileManager.fileExists(atPath: path, isDirectory: &isDir) {
                if !isDir.boolValue {
                    dirArray.append(fileName)
                }
            }
        }
        return dirArray
    }
    
    
    //查看文件夹是否存在
    class func  isJudgeFileOrFolderExists(folderName: String) -> Bool{
        let fileManager = FileManager.default
        let exist = fileManager.fileExists(atPath: folderName)
        if (exist) {
            return true
        }else{
            return false
        }
    }
    
    //删除目录下的所有文件
    class func createFolderInDocumentObjects(fileName:String) ->Bool{
        if fileName != ""{
            let paths = self.getDocumentPath()
            let userDirectory = paths+fileName
            let fileManager = FileManager.default
            if(!fileManager.fileExists(atPath: userDirectory)){
                try! fileManager.createDirectory(atPath: userDirectory, withIntermediateDirectories: false, attributes: nil)
                return true
            }
        }
        return false
    }
    
    //移除文件
    class func removefile(folderName: String){
        if folderName == ""{
            return
        }
        let fileManager = FileManager.default
        try! fileManager.removeItem(atPath: folderName)
    }
    
    //移除文件夹下所有文件
    class func deleteFileAtPath(folderName: String){
        let paths = self.getDocumentPath()
        let folderDirectory = paths+folderName
        let fileManager = FileManager.default
        let enmerator = fileManager.enumerator(atPath: folderDirectory)
        for fileName in enmerator! {
            let filePath = folderDirectory.appendingFormat("\(fileName)")
            try! fileManager.removeItem(atPath: filePath)
        }
        
    }
    
    //获取文件创建时间
    class func getFileCreateTime(filePath:String)->String {
        let fileManager = FileManager.default
        let attributes = try! fileManager.attributesOfItem(atPath: filePath)
        return String(describing: attributes[FileAttributeKey.creationDate]!)
    }
    
    //获取文件大小
    class func getFileSize(folderPath: String)-> String{
        if folderPath.count == 0 {
            return "0MB" as String
        }
        let manager = FileManager.default
        if !manager.fileExists(atPath: folderPath){
            return "0MB" as String
        }
        var fileSize:Float = 0.0
        do {
            let files = try manager.contentsOfDirectory(atPath: folderPath)
            
            for file in files {
                let path = folderPath + file
                fileSize = fileSize + fileSizeAtPath(filePath: path)
            }
        }catch{
            fileSize = fileSize + fileSizeAtPath(filePath: folderPath)
        }
        
        var resultSize = ""
        if fileSize >= 1024.0*1024.0{
            resultSize = NSString(format: "%.2fMB", fileSize/(1024.0 * 1024.0)) as String
        }else if fileSize >= 1024.0{
            resultSize = NSString(format: "%.fkb", fileSize/(1024.0 )) as String
        }else{
            resultSize = NSString(format: "%llub", fileSize) as String
        }
        
        return resultSize
    }
    
    /**  计算单个文件或文件夹的大小 */
    class func fileSizeAtPath(filePath:String) -> Float {
        
        let manager = FileManager.default
        var fileSize:Float = 0.0
        if manager.fileExists(atPath: filePath) {
            do {
                let attributes = try manager.attributesOfItem(atPath: filePath)
                if attributes.count != 0 {
                    fileSize = attributes[FileAttributeKey.size]! as! Float
                }
            }catch{
            }
        }
        return fileSize;
    }
    
    //创建文件夹
    class func createDir(dir:String)->Bool{
        let fileManager = getFileManager()
        do{
            try fileManager.createDirectory(at: NSURL(fileURLWithPath: dir, isDirectory: true) as URL, withIntermediateDirectories: true, attributes: nil)
        }catch{
            return false
        }
        return true
    }
    
}
