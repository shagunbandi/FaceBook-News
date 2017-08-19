//
//  HomeViewController.swift
//  FacebookFeeds
//
//  Created by Shagun Bandi on 12/08/17.
//  Copyright © 2017 Shagun Bandi. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var feeds: [Feed]?
    
    func fetchPages() {
        ApiService.sharedInstance.fetchPages()
    }
    
    func fetchFeeds() {
        ApiService.sharedInstance.fetchFeeds { (feeds: [Feed]) in
            self.feeds = feeds
            self.collectionView?.reloadData()
        }
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
        
//        Solve this bug
//        navigationController?.hidesBarsOnSwipe = true

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
            let height = view.frame.width + 72 + 50 + heightsOfPosts
            return CGSize(width: view.frame.width, height: height)
        }
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


