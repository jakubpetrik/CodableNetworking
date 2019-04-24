//  Copyright © 2018 Jakub Knejzlik. All rights reserved.

import Foundation

public protocol CustomDateEncodable: Encodable {
    static var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy { get }
}

public protocol CustomKeyEncodable: Encodable {
    static var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { get }
}

public protocol CustomDateDecodable: Decodable {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

public protocol CustomKeyDecodable: Decodable {
    static var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
}

public extension Encodable {
    func serialize<T: Serializer>() throws -> T {
        return try T.serialize(data: self)
    }
}

public extension Decodable {
    static func deserialize<T: Deserializer>(input: T) throws -> Self {
        return try input.deserialize()
    }
}

public protocol Serializer {
    static func serialize<T: Encodable>(data: T) throws -> Self
}

public protocol Deserializer {
    func deserialize<T: Decodable>() throws -> T
}

extension Data: Serializer, Deserializer {
    public static func serialize<T: Encodable>(data: T) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = (T.self as? CustomDateEncodable.Type)?.dateEncodingStrategy ?? .iso8601
        encoder.keyEncodingStrategy = (T.self as? CustomKeyEncodable.Type)?.keyEncodingStrategy ?? .useDefaultKeys
        return try encoder.encode(data)
    }

    public func deserialize<T: Decodable>() throws -> T {
        if let data = self as? T {
            return data
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = (T.self as? CustomDateDecodable.Type)?.dateDecodingStrategy ?? .iso8601
        decoder.keyDecodingStrategy = (T.self as? CustomKeyDecodable.Type)?.keyDecodingStrategy ?? .useDefaultKeys
        return try decoder.decode(T.self, from: self)
    }
}
