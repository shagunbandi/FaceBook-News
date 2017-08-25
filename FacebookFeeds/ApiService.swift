//
//  ApiService.swift
//  FacebookFeeds
//
//  Created by Shagun Bandi on 19/08/17.
//  Copyright © 2017 Shagun Bandi. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    let your_token = ""
    
//    var pagesURLs = ["ktj.iitkgp","TSG.IITKharagpur","scholarsavenue"]
    var pagesURLs = ["ktj.iitkgp"]
    
    var allPageUrls = [String]()
    
    var pages: [String: Page]?
    
    func fetchFeeds( completion: @escaping ([Feed]) -> () ) {

        let daysInUNIXtime = 60 * 60 * 24
        let Days5 = Int(NSDate().timeIntervalSince1970) - 2 * daysInUNIXtime
        
        let u = "https://graph.facebook.com/posts?ids=\(self.pagesURLs.joined(separator: ","))&since=\(Days5)&fields=message,id,full_picture,picture,created_time&access_token=\(your_token)"
        let urlStr: String = u.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let searchURL = URL(string: urlStr as String)!
        
        URLSession.shared.dataTask(with: searchURL as URL) { (data, response, error) in
            if error != nil {
                print("Error in fetching Data")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print("Got the f&*^)*ing JSON File")
                let dictionary = json as! [String: AnyObject]
                var feeds = [Feed]()
                for page in self.pagesURLs {
                    let pageDict = dictionary[page]
                    for dict in pageDict?["data"] as! [[String: AnyObject]] {
                        let feed = Feed()
                        
                        feed.id = dict["id"] as? String
                        if StarID.starIds.contains(feed.id!) {
                            feed.isFav = true
                        } else {
                            feed.isFav = false
                        }
                        
                        // Message
                        feed.message = dict["message"] as? String
                        if let msg = feed.message {
                            let size = CGSize(width: UIScreen.main.bounds.size.width - 16 - 16, height: 1000)
                            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                            let estimatesRect = NSString(string: msg).boundingRect(with: size, options: options, attributes:[NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
                            let height = estimatesRect.size.height
                            feed.height = height
                        }
                        else {
                            feed.height = CGFloat(0)
                        }
                        
                        // Main Image
                        feed.thumbnailImageName = dict["full_picture"] as? String
                        
                        // Date
                        let timeString = dict["created_time"]! as? String
                        let deFormatter = DateFormatter()
                        deFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        feed.date = deFormatter.date(from: timeString!)
                        
                        // Page
                        feed.page = (self.pages?[page])!
                        feed.pageURL = page
                        
                        feeds.append(feed)
                        feeds = feeds.sorted(by: { $0.date! > $1.date! })
                        
                    }
                }
                print("Reloading Data")
                DispatchQueue.main.async {
                    completion(feeds)
                }
                print("Done")
                
            }
            catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    
    func fetchFavFeeds( completion: @escaping ([Feed]) -> () ) {
        
        let u = "https://graph.facebook.com/?ids=\(StarID.starIds.joined(separator: ","))&fields=from,message,id,full_picture,picture,created_time&access_token=\(your_token)"
        
        
//        print(u)
//        print(StarID.starIds)
//        print(StarID.pageUrls)
//        print(self.pages)
        
        let urlStr: String = u.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let searchURL = URL(string: urlStr as String)!
        
        URLSession.shared.dataTask(with: searchURL as URL) { (data, response, error) in
            if error != nil {
                print("Error in fetching Data")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print("Got the f&*^)*ing JSON File")
                let dictionary = json as! [String: AnyObject]
                var feeds = [Feed]()
                for id in StarID.starIds {
                    let idDict = dictionary[id] as! [String: AnyObject]
                    
                    let feed = Feed()
                    
                    // Feed Id
                    feed.id = idDict["id"] as? String
                    
                    // Starred
                    if StarID.starIds.contains(feed.id!) {
                        feed.isFav = true
                    } else {
                        feed.isFav = false
                    }
                    
                    // Message
                    feed.message = idDict["message"] as? String
                    if let msg = feed.message {
                        let size = CGSize(width: UIScreen.main.bounds.size.width - 16 - 16, height: 1000)
                        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                        let estimatesRect = NSString(string: msg).boundingRect(with: size, options: options, attributes:[NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
                        let height = estimatesRect.size.height
                        feed.height = height
                    }
                    else {
                        feed.height = CGFloat(0)
                    }
                    
                    // Main Image
                    feed.thumbnailImageName = idDict["full_picture"] as? String
                    
                    // Date
                    let timeString = idDict["created_time"]! as? String
                    let deFormatter = DateFormatter()
                    deFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    feed.date = deFormatter.date(from: timeString!)
                    
                    // Page
                    let pageID = idDict["from"]?["id"] as? String
//                    print(pageID)
                    feed.page = (self.pages?[pageID!])!
                    
                    feeds.append(feed)
                    feeds = feeds.sorted(by: { $0.date! > $1.date! })
                }
                print("Reloading Data")
                DispatchQueue.main.async {
                    completion(feeds)
                }
                print("Done")
                
            }
            catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    func fetchPages() {
        
        self.allPageUrls = pagesURLs
        
        if let favFeedsPageUrls = UserDefaults.standard.object(forKey: "FavsPageUrl") as? [String] {
            for pageUrls in favFeedsPageUrls {
                if !self.allPageUrls.contains(pageUrls) {
                    self.allPageUrls.append(pageUrls)
                }
            }
        }
        
        let u = "https://graph.facebook.com/?ids="+self.allPageUrls.joined(separator: ",")+"&fields=picture{url},name,id&access_token=\(your_token)"
        let urlStr: String = u.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let searchURL = URL(string: urlStr as String)!
        URLSession.shared.dataTask(with: searchURL as URL) { (data, response, error) in
            if error != nil {
                print("Error in fetching Data")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print("Got the f&*^)*ing JSON File")
                let dictionary = json as! [String: AnyObject]
                self.pages = [String: Page]()
                for page in self.allPageUrls {
                    let pageDict = dictionary[page]
                    let pageInfo = Page()
                    
                    // Page Id
                    pageInfo.id = pageDict?["id"] as? String
                    
                    // Page URL
                    pageInfo.pageURL = page
                    
                    // Page Logo
                    let logo = pageDict?["picture"] as! [String:[String:AnyObject]]
                    pageInfo.logo = logo["data"]?["url"] as? String
                    
                    // Page Title
                    if let title = pageDict?["name"] as? String {
                        let size = CGSize(width: UIScreen.main.bounds.size.width - 68 , height: 200)
                        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                        let estimatesRect = NSString(string: title).boundingRect(with: size, options: options, attributes:[NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
                        let height = estimatesRect.size.height
                        pageInfo.title = title
                        pageInfo.height = height
                    }
                    else {
                        pageInfo.height = CGFloat(0)
                    }
                    
                    self.pages?[page] = pageInfo
                    self.pages?[pageInfo.id!] = pageInfo
                }
            }
            catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
}
