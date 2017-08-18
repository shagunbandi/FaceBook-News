//
//  feed.swift
//  FacebookFeeds
//
//  Created by Shagun Bandi on 14/08/17.
//  Copyright © 2017 Shagun Bandi. All rights reserved.
//

import UIKit

class Page: NSObject {
    var logo: String?
    var pageURL: String?
    var title: String?
}

class Feed: NSObject {
    var thumbnailImageName: String?
    var message: String?
    var page = Page()
    var height: CGFloat?
    
}
