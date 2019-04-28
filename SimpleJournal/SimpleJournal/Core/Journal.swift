//
//  Journal.swift
//  SimpleJournal
//
//  Created by yinzixie on 14/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import Foundation
import UIKit

class Journal {
    static let MonthString = ["Jan","Feb","Mar","Apr","May","June","July","Aug","Sept","Oct","Nov","Dec"]
    
    var ID:String!
    var Title:String!
    
    var Date_:Date!
    var DateString:String! //yyyy-MM-dd  HH:mm:ss
    var Year:Int!
    var Month:Int!
    var Day:Int!
    var Time:String! //example 13:00
    
    var Location:String!
    var Mood:String!
    var Weather:String!
    var TextContent:String!
    
    var DisplayPic:String!
    var PicsTableID:String!
    var PicsList:[UIImage] = []
    
    var Shared:Int! //0 false 1 true
    
    init() {
        ID = DateInfo.dateToDateString(Date(), dateFormat:"yyyyMMddHHmmss")//generate by date
        Title = "Journal Title"
        
        setDateAndRelevantData(date:Date())
        
        //time
        Time = String(DateString.suffix(8)) //后8个字符
        
        Location = "LocationNone"
        Mood = "MoodNone"
        Weather = "WeatherNone"
        TextContent = "ContentNone" //avoid user type none cause conflic
        DisplayPic = "PicNone"
        PicsTableID = ID
        
        Shared = 0
    }
    
    //set date and relevant data (date, dateString, year, month, day)
    func setDateAndRelevantData(date:Date) {
        Date_ = date
        DateString = DateInfo.dateToDateString(Date_, dateFormat: "yyyy-MM-dd  HH:mm:ss")
        Year = Int(DateString.prefix(4)) //前4个字符
        
        //截取第5-6个字符串 year
        let index6 = DateString.index(DateString.startIndex, offsetBy: 5)
        let index8 = DateString.index(DateString.startIndex, offsetBy: 7)
        
        Month = Int(DateString[index6..<index8])
        
        //9-10 month
        let index9 = DateString.index(DateString.startIndex, offsetBy: 8)
        let index11 = DateString.index(DateString.startIndex, offsetBy: 10)
        Day = Int(DateString[index9..<index11])
    }
    
    //generate share list
    func generateShareList(picIDList:[String])->[Any?] {
        var result = [Any?]()
        
        let TitleMessage = Title
        result += [TitleMessage]
        
        let DateMessage = "Time: " + DateString
        result += [DateMessage]
        
        let LocationMessage = "Location: " + Location
        result += [LocationMessage]
        
        let MoodMessage = "Feeling: " + Mood
        result += [MoodMessage]
        
        let WeatherMessage = "Weather: " + Weather
        result += [WeatherMessage]
        
        let ContentMessage = TextContent
        result += [ContentMessage]
        
        //get pics
        PicsList = Tools.getUIImageList(picList: picIDList)
        
        for pic in PicsList {
            result += [pic]
        }
        return result
    }
}

