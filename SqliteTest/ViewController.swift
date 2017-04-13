//
//  ViewController.swift
//  SqliteTest
//
//  Created by Eros on 2017/4/12.
//  Copyright © 2017年 Eros. All rights reserved.
//

import UIKit

extension Array {
    
    func filterDuplicates(includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}


class ResultCell: UITableViewCell {
    
    @IBOutlet weak var resultName: UILabel!
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    let locateDBManager = LocateDBManager.getInstance()
    var filteredArray = [CountryLocale]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!
    override func viewDidLoad() {
        let image = UIImage()
        searchBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        searchBar.scopeBarBackgroundImage = image
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
//        textFieldInsideSearchBar?.textColor = Config.PRIMARY_FONT_COLOR
        textFieldInsideSearchBar?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        searchBar.delegate?.searchBar!(searchBar, textDidChange: Locale(identifier: "en_US").regionCode ?? "US")
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        view.addGestureRecognizer(tap)

    }
    
//    func dismissKeyboard() {
//        view.endEditing(true)
//    }
    
    // MARK: - UISeatchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredArray = [CountryLocale]()
            if Int(searchText) != nil {
                filteredArray = locateDBManager.searchByPostalCode(keyword: searchText)
            } else {
                filteredArray = locateDBManager.searchByNameOrState(keyword: searchText)
            }
        }
        DispatchQueue.main.async {
            self.resultTableView.reloadData()
        }
        
    }
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as! ResultCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
//        cell.textLabel?.textColor = Config.PRIMARY_FONT_COLOR
        cell.resultName?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        if filteredArray.count != 0 {
            cell.resultName?.text = "\(filteredArray[indexPath.row].placeName), \(filteredArray[indexPath.row].stateCode), \(filteredArray[indexPath.row].nationalName)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ResultCell
        searchBar.text = cell.resultName.text
        searchBar.resignFirstResponder()
    }
   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor.clear
        let layer: CAShapeLayer = CAShapeLayer()
        let bounds: CGRect = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height)
        
        let lineLayer: CALayer = CALayer()
        let lineHeight: CGFloat = (1.0 / UIScreen.main.scale)
        lineLayer.frame = CGRect(x: bounds.minX, y: bounds.size.height-lineHeight, width: bounds.size.width, height: lineHeight)
        lineLayer.backgroundColor = UIColor(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        layer.addSublayer(lineLayer)
        
        let clearView: UIView = UIView(frame: bounds)
        clearView.layer.insertSublayer(layer, at: 0)
        clearView.backgroundColor = UIColor.clear
        cell.backgroundView = clearView
    }
    
}

