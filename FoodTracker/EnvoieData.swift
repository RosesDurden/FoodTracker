//
//  EnvoieData.swift
//  FoodTracker
//
//  Created by Roses on 26/09/2018.
//  Copyright © 2018 Roses. All rights reserved.
//

import Foundation

protocol EnvoieDataProtocol: class {
    func itemsDownloaded(items: NSArray)
}


class EnvoieData: NSObject, URLSessionDataDelegate {
    
    weak var delegate: EnvoieDataProtocol!
    let urlPath = "127.0.0.1/api/api_webService.php"
    
    func downloadItems() {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error")
            }else {
                print("stocks downloaded")
                self.parseJSON(data!)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        do
        {
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError { print(error)}
        
        var jsonElement = NSDictionary()
        let stocks = NSMutableArray()
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            let stock = RecupereData()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let comLib = jsonElement["comLib"] as? String,
                let depLib = jsonElement["depLib"] as? String
                
            {
                print(comLib)
                print(depLib)
                stock.comLib = comLib
                stock.depLib = depLib
            }
            stocks.add(stock)
        }
        DispatchQueue.main.async(execute: { () -> Void in self.delegate.itemsDownloaded(items: stocks)})
    }
}
