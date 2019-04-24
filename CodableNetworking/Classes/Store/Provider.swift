//
//  Provider.swift
//  CodableNetworking
//
//  Created by Jakub Petrík on 4/19/19.
//

import Foundation

enum CodableNetworkError: Swift.Error {
    case emptyResponseData
}

public protocol CodableStoreProviderRequest {
    var debugDescription: String { get }
}

public protocol CodableStoreProviderResponse {
    var debugDescription: String { get }
    func deserialize<T: Decodable>() throws -> T
}

public protocol Provider {
    associatedtype RequestType: CodableStoreProviderRequest
    associatedtype ResponseType: CodableStoreProviderResponse

    typealias ResponseHandler = (Result<ResponseType, Error>) -> Void

    func send(_ request: RequestType, _ handler: @escaping ResponseHandler)
}

extension URLRequest: CodableStoreProviderRequest {
    public var debugDescription: String {
        var curl = String(format: "curl -v -X %@", httpMethod ?? "UNKNOWN")

        if let url = url {
            curl.append(" '\(url.absoluteString)'")
        }

        allHTTPHeaderFields?.forEach({ (item) in
            curl.append(" -H '\(item.key): \(item.value)'")
        })

        if let body = httpBody, let bodyString = String.init(data: body, encoding: .utf8) {
            curl.append(" -d '\(bodyString)'")
        }

        return curl
    }
}

public enum URLSessionCodableError: Error {
    case unexpectedError(_ error: Error)
    case unexpectedStatusCode(_ response: UnexpectedStatusCodeResponse)
}

public struct UnexpectedStatusCodeResponse {
    public let statusCode: Int
    public let response: HTTPURLResponse
    public let data: Data

    public func decodeData<T: Decodable>() throws -> T {
        return try data.deserialize()
    }
}

public struct URLSessionCodableResponse: CodableStoreProviderResponse {
    public let data: Data?
    public let response: URLResponse?

    public var debugDescription: String {
        if let data = data, let res = String(data: data, encoding: .utf8) {
            return res
        }
        return "empty response"
    }

    public func deserialize<T>() throws -> T where T : Decodable {
        guard let data = data else {
            throw CodableNetworkError.emptyResponseData
        }
        return try data.deserialize()
    }
}
