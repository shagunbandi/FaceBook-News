//
//  HomeViewController.swift
//  FacebookFeeds
//
//  Created by Shagun Bandi on 12/08/17.
//  Copyright © 2017 Shagun Bandi. All rights reserved.
//

import UIKit

struct StarID {
    static var starIds: [String] = []
}

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let favoriteId = "favoriteId"
            
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationItem.title = "Home"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadFavFeedsIds()
    }
    
    func loadFavFeedsIds() {
        if let favFeeds = UserDefaults.standard.object(forKey: "Favs") as? [String] {
            for feedIds in favFeeds {
                StarID.starIds.append(feedIds)
            }
        } else {
            UserDefaults.standard.set([], forKey: "Favs")
        }
    }
    
    func setupCollectionView() {
        if let flowlayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.scrollDirection = .horizontal
            flowlayout.minimumLineSpacing = 0
        }
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(Feeds.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(Favorites.self, forCellWithReuseIdentifier: favoriteId)
        collectionView?.contentInset = UIEdgeInsetsMake(100, 0, 150, 0)
        
        // Bug with the collectionView Size Ep13 13min
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(100, 0, 150, 0)
        
        collectionView?.isPagingEnabled = true
    }
    
    func setupNavBarButtons() {
        let searchImage = UIImage(named: "Search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        navigationItem.rightBarButtonItems = [searchBarButton]
    }
    
    func handleSearch() {
        scrollToMenuAtIndexPath(menuIndex: 2)
    }
    
    func scrollToMenuAtIndexPath(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
        setTitleForIndex(index: menuIndex)
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstrainsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstrainsWithFormat(format: "V:[v0(50)]|", views: menuBar)

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: favoriteId, for: indexPath)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    let titles = ["Home", "Favorites", "Profile"]
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: false, scrollPosition: .left)
        setTitleForIndex(index: Int(index))
    }
    
    func setTitleForIndex(index: Int) {
        navigationItem.title = titles[Int(index)]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 100)
    }
}


