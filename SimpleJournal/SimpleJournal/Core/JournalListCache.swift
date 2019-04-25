//
//  JournalListCache.swift
//  SimpleJournal
//
//  Created by yinzixie on 25/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import Foundation

protocol TellHomePageCacheRefresh {
    func remindHomePageCacheChanged()
    func remindHomePageDeleteAJournal(indexPathInTable:IndexPath)
}

protocol TellManagementPageCacheRefresh {
    func remindManagementPageCacheChanged()
    func remindManagementPageDeleteAJournal(indexPathInTable: IndexPath)
}

public class JournalListCache {
    
    static var tellHomePageCacheRefresh:TellHomePageCacheRefresh?
    static var tellManagementPageCacheRefresh:TellManagementPageCacheRefresh?
    
    static var Database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    
    static var JournalList = JournalListCache.Database.selectAllJournal()
    
    class func refresh() {
        JournalList = JournalListCache.Database.selectAllJournal()
        tellHomePageCacheRefresh?.remindHomePageCacheChanged()
        tellManagementPageCacheRefresh?.remindManagementPageCacheChanged()
    }
    
    class func deleteJournal(journal:Journal,indexPathInTable:IndexPath) {
        if(Database.deleteJournal(journal: journal)) {
            
            JournalList = JournalListCache.Database.selectAllJournal()
            
            tellHomePageCacheRefresh?.remindHomePageDeleteAJournal(indexPathInTable:indexPathInTable)
            tellManagementPageCacheRefresh?.remindManagementPageDeleteAJournal(indexPathInTable:indexPathInTable)
        }
    }
}
