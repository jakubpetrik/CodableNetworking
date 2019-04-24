//  Copyright © 2019 Jakub Petrík. All rights reserved.

import Foundation

public protocol Environment {
    static var baseURL: URL { get }
    static func request<T>(_ endpoint: Endpoint<T>) -> Request<T, Self>
    static func providerRequest<T: Decodable>(_ endpoint:Endpoint<T>) -> URLRequest
}

extension Environment {
    public static func GET<T>(_ path: String) -> Endpoint<T> {
        return Endpoint(.get, path)
    }
    public static func POST<U,T>(_ path: String) -> PayloadEndpoint<U,T> {
        return PayloadEndpoint(.post, path)
    }
    public static func PUT<U,T>(_ path: String) -> PayloadEndpoint<U,T> {
        return PayloadEndpoint(.put, path)
    }
    public static func PATCH<U,T>(_ path: String) -> PayloadEndpoint<U,T> {
        return PayloadEndpoint(.patch, path)
    }
    public static func DELETE<T>(_ path: String) -> Endpoint<T> {
        return Endpoint(.delete, path)
    }

    public static func request<T>(_ endpoint: Endpoint<T>) -> Request<T,Self> {
        return Request(url: baseURL, request: providerRequest(endpoint))
    }

    public static func providerRequest<T: Decodable>(_ endpoint: Endpoint<T>) -> URLRequest {
        return endpoint.getRequest(url: baseURL)
    }
}
