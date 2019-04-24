//
//  Adapter.swift
//  CodableStore
//
//  Created by Jakub Knejzlik on 09/03/2018.
//

import Foundation

open class Adapter<E: Environment> {

    public init() { }

    open func transform(request: URLRequest) -> URLRequest {
        return request
    }

    open func transform(response: URLSessionCodableResponse) -> URLSessionCodableResponse {
        return response
    }
    
    open func handle<T: Decodable>(error: Swift.Error) throws -> T? {
        return nil
    }
}

