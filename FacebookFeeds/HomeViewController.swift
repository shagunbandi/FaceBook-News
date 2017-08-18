//
//  HomeViewController.swift
//  FacebookFeeds
//
//  Created by Shagun Bandi on 12/08/17.
//  Copyright © 2017 Shagun Bandi. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let your_token = "your token"
    
    let pagesURLs = ["ktj.iitkgp","TSG.IITKharagpur","scholarsavenue"]
//    let pagesURLs = ["ktj.iitkgp"]
    
    var feeds: [Feed]?
    
    var pages: [String: Page]?
    
    var heights: [CGFloat]?
    
    func fetchPages() {
        let u = "https://graph.facebook.com/?ids="+self.pagesURLs.joined(separator: ",")+"&fields=picture{url},name,id&access_token=\(your_token)"
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
                for page in self.pagesURLs {
                    let pageDict = dictionary[page]
                    let pageInfo = Page()
                    
                    // Page URL
                    pageInfo.pageURL = page
                    
                    // Page URL
                    let logo = pageDict?["picture"] as! [String:[String:AnyObject]]
                    pageInfo.logo = logo["data"]?["url"] as? String
                    
                    // Page Title
                    if let title = pageDict?["name"] as? String {
                        let size = CGSize(width: self.view.frame.width - 68 , height: 200)
                        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                        let estimatesRect = NSString(string: title).boundingRect(with: size, options: options, attributes:[NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
                        let height = estimatesRect.size.height
                        pageInfo.title = title
                        pageInfo.height = height
//                        print("\(pageInfo.title) - \(pageInfo.height)")
                    }
                    else {
                        pageInfo.height = CGFloat(0)
                    }

                    self.pages?[page] = pageInfo
                }
            }
            catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    func fetchFeeds() {
        let u = "https://graph.facebook.com/posts?ids="+self.pagesURLs.joined(separator: ",")+"&limit=6&fields=message,id,full_picture,picture,created_time&access_token=\(your_token)"
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
                self.feeds = [Feed]()
                for page in self.pagesURLs {
                    let pageDict = dictionary[page]
                    for dict in pageDict?["data"] as! [[String: AnyObject]] {
                        let feed = Feed()
                        
                        // Message
                        feed.message = dict["message"] as? String
                        if let msg = feed.message {
                            let size = CGSize(width: self.view.frame.width - 16 - 16, height: 1000)
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
                        
                        self.feeds?.append(feed)
                        self.feeds = self.feeds?.sorted(by: { $0.date! > $1.date! })

                    }
                }
                print("Reloading Data")
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                print("Done")
                self.setHeights()

            }
            catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    func setHeights() {
        heights = [CGFloat]()
        for feed in self.feeds! {
//            DispatchQueue.main.async {
//            }
            let height = feed.height!
//            print(height)
            self.heights?.append(height)
        }
//        print("&^*&^(*&^(*&^(*&^(*&^(*&^(*&%*&^$*%$&%^$*&^%*&^%*%$&^%$^%$^%$&^%$")
//        print(heights!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPages()
        fetchFeeds()
        
        navigationItem.title = "Home"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: "cellId")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        
        
        
        setupMenuBar()
        setupNavBarButtons()
    }
    
    func setupNavBarButtons() {
        let searchImage = UIImage(named: "Search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        navigationItem.rightBarButtonItems = [searchBarButton]
    }
    
    func handleSearch() {
        print(123)
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstrainsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstrainsWithFormat(format: "V:[v0(50)]|", views: menuBar)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! FeedCell
        cell.backgroundColor = UIColor.white
        cell.feed = feeds?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let heightsOfPosts = feeds?[indexPath.item].height {
            let height = view.frame.width + 72 + 24 + heightsOfPosts
            return CGSize(width: view.frame.width, height: height)
        }
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


