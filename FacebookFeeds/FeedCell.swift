//
//  FeedCell.swift
//  FacebookFeeds
//
//  Created by Shagun Bandi on 13/08/17.
//  Copyright © 2017 Shagun Bandi. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        // Override the function when making a child class
    }
}

class FeedCell: BaseCell {
    
    var feed: Feed? {
        didSet {
            
            //Feed Assets
            message.text = feed?.message
            setupThumbnailImage()
            if (feed?.isFav)! {
                favoriteButton.alpha = 1
                starred = true
            } else {
                favoriteButton.alpha = 0.1
                starred = false
            }
            
            //Page Assets
            if let feedPageURL = feed?.page.pageURL {
                pageURL.text = feedPageURL
            }
            if let pageTitle = feed?.page.title {
                titleLabel.text = pageTitle
                
                DispatchQueue.main.async {
                    if (self.feed?.page.height)! > 22 {
                        self.titleLabelHeightConstraint?.constant = 44
                    }
                    else{
                        self.titleLabelHeightConstraint?.constant = 20
                    }
                }
            }
            setupPageImage()
            DispatchQueue.main.async {
                self.messageHeightConstraint?.constant = (self.feed?.height)!
            }
            
        }
    }
    
    func setupPageImage() {
        if let thumbnailImageURL = feed?.page.logo {
            userProfileImageView.setImageThumbnailByURL(imageURL: thumbnailImageURL)
        }
    }
    
    func setupThumbnailImage() {
        if let thumbnailImageURL = feed?.thumbnailImageName {
            thumbnailImageView.setImageThumbnailByURL(imageURL: thumbnailImageURL)
        }
    }
    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = UIColor.black
//        imageView.image = UIImage(named: "KTJArticle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = UIColor.green
//        imageView.image = UIImage(named: "ktj")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var starred = false
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "star")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        button.alpha = 0.1
        button.addTarget(self, action: #selector(handleStar), for: .touchUpInside)
        return button
    }()
    
    func handleStar() {
        if starred {
            favoriteButton.alpha = 0.1
            starred = false
            self.feed?.isFav = false
            let id = self.feed?.id
            StarID.starIds = StarID.starIds.filter { $0 != id }
            
            if var favFeeds = UserDefaults.standard.object(forKey: "Favs") as? [String] {
                favFeeds = favFeeds.filter { $0 != id }
                UserDefaults.standard.set(favFeeds, forKey: "Favs")
            }
        } else {
            favoriteButton.alpha = 1
            starred = true
            feed?.isFav = true
            let id = self.feed?.id
            StarID.starIds.append(id!)
            
            if var favFeeds = UserDefaults.standard.object(forKey: "Favs") as? [String] {
                favFeeds.append(id!)
                UserDefaults.standard.set(favFeeds, forKey: "Favs")
            }
            if var favFeedsPageUrl = UserDefaults.standard.object(forKey: "FavsPageUrl") as? [String] {
                favFeedsPageUrl.append((feed?.pageURL)!)
                UserDefaults.standard.set(favFeedsPageUrl, forKey: "FavsPageUrl")
            }
        }
    }
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
//        label.text = "Shagun Bandi"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let message: UITextView = {
        let msg = UITextView()
        msg.translatesAutoresizingMaskIntoConstraints = false
        msg.font = .systemFont(ofSize: 18)
        msg.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        msg.textAlignment = .center
        return msg
    }()
    
    let pageURL: UITextView = {
        let textView = UITextView()
//        textView.text = "@shagunbandi"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    var messageHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        
//        collectionView.reloadData()
        
        backgroundColor = .white
        
        addSubview(thumbnailImageView)
        addSubview(userProfileImageView)
        addSubview(seperatorView)
        addSubview(titleLabel)
        addSubview(pageURL)
        addSubview(message)
        addSubview(favoriteButton)
        
        addConstrainsWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstrainsWithFormat(format: "H:|-16-[v0(44)]-8-[v1]-46-|", views: userProfileImageView, titleLabel)
        addConstrainsWithFormat(format: "H:|[v0]|", views: seperatorView)
        addConstrainsWithFormat(format: "H:|-16-[v0]-16-|", views: message)
        
        //Vertical Constrains
        addConstrainsWithFormat(format: "V:|-16-[v0(44)]", views: userProfileImageView)
        addConstrainsWithFormat(format: "V:[v0(1)]|", views: seperatorView)
        
        
        // Title Label Contrains
        //top Constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: userProfileImageView, attribute: .top, multiplier: 1, constant: 0))
        //left Constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
//        //right Constraint
//        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: favoriteButtonSelect, attribute: .left, multiplier: 1, constant: 8))
        //height Contrait
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20)
        addConstraint(titleLabelHeightConstraint!)
        
        
        // page URL Label Contrains
        //top Constraint
        addConstraint(NSLayoutConstraint(item: pageURL, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        //left Constraint
        addConstraint(NSLayoutConstraint(item: pageURL, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        //right Constraint
        addConstraint(NSLayoutConstraint(item: pageURL, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        //height Contrait
        addConstraint(NSLayoutConstraint(item: pageURL, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
        
        // thumbnailImageView Constrains
        //top Constraint
        addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .top, relatedBy: .equal, toItem: pageURL, attribute: .bottom, multiplier: 1, constant: 8))
        //height Constraint
        addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .height, relatedBy: .equal, toItem: thumbnailImageView, attribute: .width, multiplier: 1, constant: 0))
        
        // message Constrains
        //top Constraint
        addConstraint(NSLayoutConstraint(item: message, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        //height Constraint
        messageHeightConstraint = NSLayoutConstraint(item: message, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 10)
        addConstraint(messageHeightConstraint!)
        
        // star Constraint
        // width
        favoriteButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        // height
        favoriteButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        // right
        favoriteButton.rightAnchor.constraint(equalTo: thumbnailImageView.rightAnchor).isActive = true
        //top
        favoriteButton.topAnchor.constraint(equalTo: userProfileImageView.topAnchor).isActive = true
    }
    
}
