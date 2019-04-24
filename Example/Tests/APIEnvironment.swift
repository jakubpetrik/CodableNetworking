//
//  APIService.swift
//  CodableNetworking_Example
//
//  Created by Anna Shirokova on 24/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import CodableNetworking

let fakeAPIPath = "https://my-json-server.typicode.com/typicode/demo"

struct Post: Codable {
    let id: Int
    let title: String
}

enum APIEnvironment: Environment {
    static var baseURL: URL {
        return URL(string: fakeAPIPath)!
    }
}
