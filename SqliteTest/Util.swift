//
//  Util.swift
//  SqliteTest
//
//  Created by eros.chen on 2017/4/12.
//  Copyright © 2017年 Eros. All rights reserved.
//
import UIKit

class Util: NSObject {
    
    class func getPath(_ fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        return fileURL.path
    }

    class func copyFile() {
        let fm = FileManager.default
        let src = Bundle.main.path(forResource: "location", ofType: "sqlite")
        
        let dst = NSHomeDirectory() + "/Documents/location.sqlite"
        if !fm.fileExists(atPath: dst) {
            do {
                try fm.copyItem(atPath: src!, toPath: dst)
                print("Copy success")
            } catch {
                print(error.localizedDescription )
            
            }
        }else{
            print(fileExists)
        }
    }

}
