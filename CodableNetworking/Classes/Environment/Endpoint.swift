//  Copyright © 2019 Jakub Petrík. All rights reserved.

import Foundation

public class Endpoint<Result: Decodable> {
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }

    private var _path: String
    public var path: String {
        get {
            return parameters.reduce(_path) { path, pair in
                path.replacingOccurrences(
                    of: ":\(pair.key)\\b",
                    with: pair.value,
                    options: .regularExpression
                )
            }
        }
        set {
            _path = newValue
        }
    }

    public private(set) var parameters: [String: String] = [:]
    public private(set) var method: Method
    public private(set) var query: [String: String] = [:]

    public init(_ method: Method, _ path: String) {
        self.method = method
        _path = path
    }

    @discardableResult public func query(_ query: [String: String]) -> Self {
        self.query = query
        return self
    }

    @discardableResult public func setQueryValue(_ value: String, forKey key: String) -> Self {
        query[key] = value
        return self
    }

    @discardableResult public func with(parameters: [String: String]) -> Self {
        self.parameters = parameters
        return self
    }

    @discardableResult public func with(value: String, forParameter key: String) -> Self {
        parameters[key] = value
        return self
    }

    public func getRequest(url: URL) -> URLRequest {
        var components = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: true)!
        components.queryItems = query.compactMap(URLQueryItem.init)
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        return request
    }
}
