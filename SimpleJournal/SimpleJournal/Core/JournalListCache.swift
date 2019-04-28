//
//  JournalListCache.swift
//  SimpleJournal
//
//  Created by yinzixie on 25/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import Foundation

class MoodStatistic {
    var Num:Int?
    var Mood: String?
    
    init(num:Int,mood:String){
        Num = num
        Mood = mood
    }
}

class SearchJournalResultList {
    var journal:Journal
    var indexPath: IndexPath
    
    init(journal_:Journal,indexPath_:IndexPath) {
        journal = journal_
        indexPath = indexPath_
    }
}

protocol TellHomePageCacheRefresh {
    func remindHomePageCacheChanged()
    func remindHomePageDeleteAJournal(indexPathInTable:IndexPath)
}

protocol TellManagementPageCacheRefresh {
    func remindManagementPageCacheChanged()
    func remindManagementPageDeleteAJournal(indexPathInTable: IndexPath)
}

protocol TellStatisticPageCacheRefresh {
    func remindStatisticPageCacheChanged()
    func remindStatisticPageDeleteAJournal(indexPathInTable: IndexPath)
}

protocol TellCalendarPageCacheRefresh {
    func remindCalendarPageCacheChanged()
    //func remindCalendarPageDeleteAJournal(indexPathInTable: IndexPath)
}

public class JournalListCache {
    
    static var tellHomePageCacheRefresh:TellHomePageCacheRefresh?
    static var tellManagementPageCacheRefresh:TellManagementPageCacheRefresh?
    static var tellStatisticPageCacheRefresh:TellStatisticPageCacheRefresh?
    static var tellCalendarPageCacheRefresh:TellCalendarPageCacheRefresh?
    
    static var Database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    
    static var JournalList = JournalListCache.Database.selectAllJournal()
    static var StatisticList:[Int]?
    
    class func refresh() {
        JournalList = JournalListCache.Database.selectAllJournal()
        
        print("send refresh")
        tellHomePageCacheRefresh?.remindHomePageCacheChanged()
        tellManagementPageCacheRefresh?.remindManagementPageCacheChanged()
        tellStatisticPageCacheRefresh?.remindStatisticPageCacheChanged()
        tellCalendarPageCacheRefresh?.remindCalendarPageCacheChanged()
       
    }
    
    class func deleteJournal(journal:Journal,indexPathInTable:IndexPath) {
        if(Database.deleteJournal(journal: journal)) {
            JournalList = JournalListCache.Database.selectAllJournal()
            
            print("send refresh")
            tellHomePageCacheRefresh?.remindHomePageDeleteAJournal(indexPathInTable:indexPathInTable)
            tellManagementPageCacheRefresh?.remindManagementPageDeleteAJournal(indexPathInTable:indexPathInTable)
            tellStatisticPageCacheRefresh?.remindStatisticPageDeleteAJournal(indexPathInTable: indexPathInTable)
            tellCalendarPageCacheRefresh?.remindCalendarPageCacheChanged()
        }
    }
    
    class func statisticMoods(from:Date,to:Date)->[MoodStatistic] {
        var statistics = [MoodStatistic]()
      
        for journal in JournalList {
            if(!(DateInfo.compareOneDay(oneDay: from, withAnotherDay: DateInfo.timeStringToDate(journal.DateString)) == 1 ) && !(DateInfo.compareOneDay(oneDay: to, withAnotherDay: DateInfo.timeStringToDate(journal.DateString)) == 2 )) {

                if(statistics.filter{$0.Mood == journal.Mood}.count > 0){
                    statistics.filter{$0.Mood == journal.Mood}.first?.Num = statistics.filter{$0.Mood == journal.Mood}.first!.Num! + 1
                }else {
                    statistics += [MoodStatistic(num:1,mood:journal.Mood)]
                }
            }
        }
        
        //sort array
        return bubble_sort(list:statistics)
    }
    
    //sort array
    static func bubble_sort(list:[MoodStatistic])->[MoodStatistic]
    {
        var finish = true
        let len = list.count
        
        var result = list
       
        if(len <= 1)
        {
            return list
        }
        
        repeat{
            finish = true
           
            for i in 0..<len {
                let j = i+1
                if(j < len) {
                    //print("ss: ",i," ",j," ",result[i].Num)
                    if(result[i].Num! < result[j].Num!) {
                      
                        let temp = result[i]
                      //  print(result[i].Num, result[j].Num)
                        
                        result[i] = result[j]
                        result[j] = temp
                        finish = false
                    }
                }
            }
            print(finish)
        } while(!finish)
        
        return result
    }
    
    static func getJournalByDate(date:Date)->[SearchJournalResultList] {
        var result = [SearchJournalResultList]()
        var index = 0
        for journal in JournalList {
            if((journal.Year == date.year_()) && (journal.Month == date.month_()) && (journal.Day == date.day_())){
                let indePath = IndexPath(row: index,section: 0)
                result += [SearchJournalResultList(journal_: journal, indexPath_: indePath)]
            }
            index += 1
        }
        return result
    }
}
