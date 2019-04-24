//
//  Adapter+Logging.swift
//  CodableStore
//
//  Created by Jakub Knejzlik on 21/03/2018.
//

import Foundation

final public class LoggingAdapter<E: Environment>: Adapter<E> {

    public typealias LoggingFn = (_ items: Any...) -> Void

    public var loggingFn: LoggingFn

    public init(loggingFn: LoggingFn? = nil) {
        self.loggingFn = loggingFn ?? { (items: Any...) in
            #if DEBUG
                print(items)
            #endif
        }
    }

    override public func transform(request: URLRequest) -> URLRequest {
        self.loggingFn("[CodableStore:request]", request.debugDescription)
        return request
    }
    override public func transform(response: URLSessionCodableResponse) -> URLSessionCodableResponse {
        self.loggingFn("[CodableStore:response]", response.debugDescription)
        return response
    }
    override public func handle<T: Decodable>(error: Swift.Error) throws -> T? {
        self.loggingFn("[CodableStore:error]", error.localizedDescription)
        return nil
    }
}
