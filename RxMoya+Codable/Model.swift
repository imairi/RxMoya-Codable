//
//  Model.swift
//  RxMoya+Codable
//
//  Created by Imairi Yosuke on 2017/09/11.
//  Copyright © 2017年 Imairi Yosuke. All rights reserved.
//

import Moya

struct User: Codable {
    let description: String?
    let facebookID: String?
    let followeesCount: Int
    let followersCount: Int
    let githubLoginName: String?
    let id: String
    let itemsCount: Int
    let linkedinID: String?
    let location: String?
    let name: String
    let organization: String?
    let permanentID: Int
    let profileImageURL: String
    let twitterScreenName: String?
    let websiteURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case description
        case facebookID = "facebook_id"
        case followeesCount = "followees_count"
        case followersCount = "followers_count"
        case githubLoginName = "github_login_name"
        case id
        case itemsCount = "items_count"
        case linkedinID = "linkedin_id"
        case location
        case name
        case organization
        case permanentID = "permanent_id"
        case profileImageURL = "profile_image_url"
        case twitterScreenName = "twitter_screen_name"
        case websiteURL = "website_url"
    }
}

enum UserAPI {
    case fetch
}

// MARK: - TargetType
extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://qiita.com")!
    }
    
    var path: String {
        return "/api/v2/users"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "sample", ofType: "json")!
        return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
    }
    
    var task: Task {
        return .requestParameters(parameters: ["page":1], encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
}
