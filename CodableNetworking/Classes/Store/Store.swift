//  Copyright © 2018 Jakub Knejzlik. All rights reserved.

import Foundation

public class CodableStore<E: Environment> {
    public typealias LoggingFunction = (_ items: Any...) -> Void
    private var adapters = [Adapter<E>]()

    public var loggingFn: LoggingFunction? = nil
    public let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
        #if DEBUG
        self.loggingFn = { (items: Any...) in
            print(items)
        }
        #endif
    }

    @discardableResult public func request<T: Decodable>(_ request: URLRequest) -> Request<T,E> {
        #if DEBUG
            loggingFn?("[CodableNetworking:request]", request.debugDescription)
        #endif
        let request = adapters.reduce(request, { $1.transform(request: $0) })
        return Request(url: E.baseURL, request: request, adapters: adapters)
    }

    @discardableResult public func request<T:Decodable>(_ endpoint: Endpoint<T>) -> Request<T,E> {
        return request(E.providerRequest(endpoint))
    }

    public func addAdapter(_ adapter: Adapter<E>) {
        adapters.append(adapter)
    }

    public func send<T: Decodable>(_ endpoint: Endpoint<T>, completion: @escaping (Result<T, Error>) -> Void) {
        let request = self.request(endpoint)
        request.send(in: session, handler: completion)
    }

    public func send<T: Decodable>(_ endpoint: Endpoint<T>, sessionOverride: URLSession, completion: @escaping (Result<T, Error>) -> Void) {
        let request = self.request(endpoint)
        request.send(in: sessionOverride, handler: completion)
    }
}
