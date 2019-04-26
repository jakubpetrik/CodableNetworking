//  Copyright © 2019 Jakub Petrík. All rights reserved.

import PromiseKit

extension CodableStore {
    @discardableResult public func send<T: Decodable>(_ endpoint: Endpoint<T>) -> Promise<T> {
        return Promise<T> { seal in
            self.send(endpoint) { result in
                switch result {
                case .success(let response):
                    seal.fulfill(response)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    @discardableResult public func send<T: Decodable>(_ endpoint: Endpoint<T>, sessionOverride: URLSession) -> Promise<T> {
        return Promise<T> { seal in
            self.send(endpoint, sessionOverride: sessionOverride) { result in
                switch result {
                case .success(let response):
                    seal.fulfill(response)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
