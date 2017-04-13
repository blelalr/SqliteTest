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
    let nation:String = "US"
    
    class func getInstance() -> LocateDBManager
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: dbpath)
        }
        return sharedInstance
    }
    
    func nation(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            return name
        } else {
            return countryCode
        }
    }
    
    func searchByPostalCode(keyword: String) -> [CountryLocale]! {
        var locales = [CountryLocale]()
        
        sharedInstance.database!.open()
        let query = "SELECT * FROM Location WHERE Postalcode LIKE ? GROUP BY PlaceName ORDER BY PlaceName"
        
        do {
            let results = try sharedInstance.database!.executeQuery(query, values: ["\(keyword)%"])
            
            while results.next() {
                let locale = CountryLocale(postalCode: Int(results.int(forColumn: field_PostalCode)),
                                           placeName: results.string(forColumn: field_PlaceName),
                                           stateCode: results.string(forColumn: field_StateCode),
                                           nationalName: nation(from: nation))
            
                locales.append(locale)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        sharedInstance.database!.close()
        
        return locales
    }
    
    func searchByNameOrState(keyword: String) -> [CountryLocale]! {
        var locales = [CountryLocale]()
        if keyword == nation {
            return locales
        }
        
        sharedInstance.database!.open()
        let query = "SELECT * FROM Location WHERE PlaceName LIKE ? OR StateCode LIKE ? GROUP BY PlaceName ORDER BY PlaceName"
        
        do {
            
            let results = try sharedInstance.database!.executeQuery(query, values: ["\(keyword)%", "\(keyword)%"])
            
            while results.next() {
                let locale = CountryLocale(postalCode: Int(results.int(forColumn: field_PostalCode)),
                                           placeName: results.string(forColumn: field_PlaceName),
                                           stateCode: results.string(forColumn: field_StateCode),
                                           nationalName: nation(from: nation))
                
                locales.append(locale)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        sharedInstance.database!.close()
        
        return locales
    }

}
