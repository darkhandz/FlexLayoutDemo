//
//  TweetStore.swift
//  FlexLayoutDemo1
//
//  Created by darkhandz on 2018/7/19.
//  Copyright © 2018年 darkhandz. All rights reserved.
//

import Foundation
import CoreGraphics


class TweetStore {
    
    static let shared = TweetStore()
    private(set) var items = [TweetItem]()
    
    private init() {
        loadFromFile()
    }
    
    private func loadFromFile() {
        let url = Bundle.main.url(forResource: "tweets.json", withExtension: nil)!
        let data = try! Data(contentsOf: url)
        items = try! JSONDecoder().decode([TweetItem].self, from: data)
    }
    
    var count: Int {
        return items.count
    }
    
    func item(at index: Int) -> TweetItem {
        return items[index]
    }
}





class TweetItem: Codable {
    var uid                   = ""     //  "5677785f60b2298f122fe889",
    var user: User?                    //  {
    var content               = ""     //  "不要写代码，不要读博。",
    var pictures: [String]    = []     //  []
    var url                   = ""     //  "",
    var urlTitle              = ""     //  "",
    var urlPic                = ""     //  "",
    var commentCount          = 0      //  4,
    var likedCount            = 0      //  29,
    var isLiked               = false  //  false,
    var createdAt             = ""     //  "2018-07-16T10:12:29.498Z",
    var updatedAt             = ""     //  "2018-07-16T10:15:46.073Z",
    var topicId               = ""     //  "",
    var topic: Topic?                  //  null,
    var isTopicRecommend      = false  //  false,
    var folded                = false  //  false
    var attributedText: NSMutableAttributedString?   //  带样式的内容
    var picsSize: [String: CGSize]   = [:]     // 保存图片缩放后的尺寸
    var cellHeight: CGFloat?                  // cell高度
    
    enum CodingKeys: String, CodingKey {
        case uid, user, content, pictures, url, urlTitle, urlPic, commentCount, likedCount, isLiked, createdAt, updatedAt, topicId, topic, isTopicRecommend, folded
    }
}


struct User: Codable {
    var avatarLarge             = ""      // "https://",
    var objectId                = ""      // "5677785f60b2298f122fe889",
    var company                 = ""      // "HelloGitHub",
    var followeesCount          = 0       // 16,
    var followersCount          = 0       // 1675,
    var jobTitle                = ""      // "Pythoneer",
    var role                    = ""      // "editor",
    var username                = ""      // "削微寒",
    var currentUserFollowed     = false   // false
}


struct Topic: Codable {
    var title = ""
}
