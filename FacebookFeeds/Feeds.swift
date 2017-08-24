//
//  Feeds.swift
//  FacebookFeeds
//
//  Created by Shagun Bandi on 21/08/17.
//  Copyright © 2017 Shagun Bandi. All rights reserved.
//

import UIKit

class Feeds: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var feeds: [Feed]?
    
    let cellId = "cellId"
    
    var refreshControl = UIRefreshControl()
    
    func fetchPages() {
        ApiService.sharedInstance.fetchPages()
    }
    
    func fetchFeeds() {
        ApiService.sharedInstance.fetchFeeds { (feeds: [Feed]) in
            self.feeds = feeds
            self.collectionView.reloadData()
        }
    }
    
    func refreshStream() {
        
        print("refresh")
        fetchPages()
        fetchFeeds()
//        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func setupViews() {
        
        // Refresher
        collectionView.alwaysBounceVertical = true
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshStream), for: .valueChanged)
        refreshControl = refresher
        collectionView.addSubview(refreshControl)

        // Fetch Feeds
        fetchPages()
        fetchFeeds()
        
        super.setupViews()
        backgroundColor = .white
        
        addSubview(collectionView)
        addConstrainsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstrainsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! FeedCell
        cell.backgroundColor = UIColor.white
        cell.feed = feeds?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let heightsOfPosts = feeds?[indexPath.item].height {
            let height = frame.width + 72 + 50 + heightsOfPosts
            return CGSize(width: frame.width, height: height)
        }
    
        return CGSize(width: frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
