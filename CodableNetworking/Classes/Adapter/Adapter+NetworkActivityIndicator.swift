//
//  Adapter+NetworkStatusIndicator.swift
//  CodableStore
//
//  Created by Jakub Knejzlik on 28/03/2018.
//

import UIKit
import Foundation

final public class NetworkActivityIndicatorAdapter<E: Environment>: Adapter<E> {
    private let queue = DispatchQueue(
        label: "com.codablenetwork.networkactivityadapter.update",
        qos: .userInitiated
    )
    private var counter = 0
    private var _isNetworkActivityIndicatorVisible = false

    public var isNetworkActivityIndicatorVisible: Bool {
        var isVisible = false
        queue.sync {
            isVisible = self._isNetworkActivityIndicatorVisible
        }
        return isVisible
    }


    override public func transform(request: URLRequest) -> URLRequest {
        update(increment: 1)
        return request
    }
    override public func transform(response: URLSessionCodableResponse) -> URLSessionCodableResponse {
        update(increment: -1)
        return response
    }
    override public func handle<T: Decodable>(error: Swift.Error) throws -> T? {
        update(increment: -1)
        return nil
    }

    private func update(increment: Int) {
        queue.sync {
            self.counter += increment
            let isVisible = self.counter > 0
            self._isNetworkActivityIndicatorVisible = isVisible
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = isVisible
            }
        }
    }
}
