//  Copyright © 2019 Jakub Petrík. All rights reserved.

import Foundation

public protocol Response: CustomDebugStringConvertible {
    func deserialize<T: Decodable>() throws -> T
}
