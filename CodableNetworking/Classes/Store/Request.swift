//  Copyright © 2019 Jakub Petrík. All rights reserved.

import Foundation

extension URLSession: Provider {
    public typealias RequestType = URLRequest
    public typealias ResponseType = URLSessionCodableResponse

    public func send(_ request: URLRequest, _ handler: @escaping (Result<URLSessionCodableResponse, Error>) -> Void) {
        var task: URLSessionDataTask? = nil
        task = dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                return handler(.failure(URLSessionCodableError.unexpectedError(error)))
            }

            guard let data = data else {
                assertionFailure("no data")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
                let errorResponse = UnexpectedStatusCodeResponse(statusCode: httpResponse.statusCode, response: httpResponse, data: data)
                return handler(.failure(URLSessionCodableError.unexpectedStatusCode(errorResponse)))
            }

            let response = URLSessionCodableResponse(data: data, response: response)
            handler(.success(response))
        })
        task?.resume()
    }
}

public class Request<T: Decodable, E: Environment> {
    let url: URL
    let request: URLRequest
    private let adapters: [Adapter<E>]

    init(url: URL, request: URLRequest, adapters: [Adapter<E>] = []) {
        self.url = url
        self.request = request
        self.adapters = adapters
    }

    public func send<U: Endpoint<T>>(in session: URLSession, handler: @escaping (Result<T, Error>) -> Void) {
        session.send(request) { result in
            switch result {
            case .failure(let error): handler(.failure(error))
            case .success(let response):
                let transformedResponse = self.adapters.reduce(response) { response, adapter in
                    return adapter.transform(response: response)
                }
                do {
                    let deserialized: T = try transformedResponse.deserialize()
                    handler(.success(deserialized))
                } catch {
                    do {
                        let recovered = try self.recoverWithAdapters(error)
                        handler(.success(recovered))
                    } catch {
                        handler(.failure(error))
                    }
                }

            }
        }
    }

    private func recoverWithAdapters<U: Endpoint<T>>(_ error: Error) throws -> T {
        for adapter in adapters {
            if let result: T = try adapter.handle(error: error) {
                return result
            }
        }
        throw error
    }
}

