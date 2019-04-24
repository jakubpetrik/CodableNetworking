//
//  Response.swift
//  CodableNetworking
//
//  Created by Jakub Petrík on 4/19/19.
//

import Foundation

public protocol Response: CustomDebugStringConvertible {
    func deserialize<T: Decodable>() throws -> T
}
