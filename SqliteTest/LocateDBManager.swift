//
//  DatabaseManager.swift
//  SqliteTest
//
//  Created by Eros on 2017/4/12.
//  Copyright © 2017年 Eros. All rights reserved.
//
import UIKit
let sharedInstance = LocateDBManager()
var dbpath : String {
    get {
        let docsdir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return (docsdir as NSString).appendingPathComponent("location.sqlite")
    }
}

class LocateDBManager: NSObject {
    
    var database: FMDatabase? = nil
    
    var pathToDatabase: String!
    
    let field_PostalCode = "PostalCode"
    let field_PlaceName = "PlaceName"
    let field_StateCode = "StateCode"
    let national:String = "US"
    
    class func getInstance() -> LocateDBManager
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: dbpath)
        }
        return sharedInstance
    }
    
    func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return countryCode
        }
    }
    
//    func openDatabase() -> Bool {
//        if database == nil {
//            if FileManager.default.fileExists(atPath: pathToDatabase) {
//                database = FMDatabase(path: pathToDatabase)
//            }
//        }
//        
//        if database != nil {
//            if database.open() {
//                return true
//            }
//        }
//        
//        return false
//    }
    
    func getCountryLocales() -> [CountryLocale]! {
        
        sharedInstance.database!.open()
        
//        let query = "select * order by PostalCode asc"
        let results: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM 'Location' ", withArgumentsIn: nil)
        var locales: [CountryLocale]!
        if (results != nil) {
            while results.next() {
                let locale = CountryLocale(postalCode: Int(results.int(forColumn: field_PostalCode)),
                                           placeName: results.string(forColumn: field_PlaceName),
                                           stateCode: results.string(forColumn: field_StateCode),
                                           nationalName: countryName(from: national))
                if locales == nil {
                    locales = [CountryLocale]()
                }
                
                locales.append(locale)
            }
            
        }
        sharedInstance.database!.close()
    
        return locales
    }

}
