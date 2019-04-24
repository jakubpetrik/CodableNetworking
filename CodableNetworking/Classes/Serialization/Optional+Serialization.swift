//  Copyright © 2019 Jakub Petrík. All rights reserved.

import Foundation

extension Optional: CustomDateEncodable where Wrapped: CustomDateEncodable {
    public static var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        return Wrapped.dateEncodingStrategy
    }
}

extension Optional: CustomKeyEncodable where Wrapped: CustomKeyEncodable {
    public static var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy {
        return Wrapped.keyEncodingStrategy
    }
}

extension Optional: CustomDateDecodable where Wrapped: CustomDateDecodable {
    public static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return Wrapped.dateDecodingStrategy
    }
}

extension Optional: CustomKeyDecodable where Wrapped: CustomKeyDecodable {
    public static var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return Wrapped.keyDecodingStrategy
    }
}
