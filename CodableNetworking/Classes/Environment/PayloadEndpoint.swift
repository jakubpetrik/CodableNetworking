//  Copyright © 2019 Jakub Petrík. All rights reserved.

import Foundation

public class PayloadEndpoint<U: Encodable, T: Decodable>: Endpoint<T> {
    public var body: U? = nil

    @discardableResult public func body(body: U) -> Self {
        self.body = body
        return self
    }

    override public func getRequest(url: URL) -> URLRequest {
        var request = super.getRequest(url: url)
        do {
            request.httpBody = try body?.serialize()
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {}
        return request
    }
}
