//
//  Movie.swift
//  To-Do App
//
//  Created by Damian Roszczyk on 22/04/2019.
//  Copyright © 2019 Damian Roszczyk. All rights reserved.
//

import Foundation
import UIKit

class GitHubUser : Decodable {
    var avatar_url : String
    var login : String
    var repos_url : String
    var repos : [Repository]?

    private enum CodingKeys: String, CodingKey {
        case avatar_url
        case login
        case repos_url
    }
    
    init() {
        avatar_url = ""
        login = ""
        repos_url = ""
    }
}
