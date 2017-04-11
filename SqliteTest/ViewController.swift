//
//  ViewController.swift
//  SqliteTest
//
//  Created by Eros on 2017/4/12.
//  Copyright © 2017年 Eros. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let databaseManager = DatabaseManager()
    
    override func viewDidLoad() {
        if databaseManager.openDatabase() {
            print("db is open.")
        }
    }
    
}

