import XCTest
import CodableNetworking

class Tests: XCTestCase {
    let store = CodableStore<APIEnvironment>()

    func testPost() {
        let expectation = self.expectation(description: "Response")
        let endpoint: PayloadEndpoint<Post, Post> = APIEnvironment.POST("/posts")
        let expected = Post(id: 4, title: "New Post")
        store
            .send(endpoint.body(body: expected))
            .done { post in
                XCTAssertEqual(expected.id, post.id)
                XCTAssertEqual(expected.title, post.title)
                expectation.fulfill()
            }
            .catch { error in
                XCTAssert(false, "\(error)")
            }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGet() {
        let expectation = self.expectation(description: "Response")
        let endpoint: Endpoint<[Post]> = APIEnvironment.GET("/posts")
        store
            .send(endpoint)
            .done { posts in
                XCTAssertEqual(posts.count, 3)
                expectation.fulfill()
            }.catch { error in
                XCTAssert(false, "\(error)")
            }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetWithParameter() {
        let expectation = self.expectation(description: "Response")
        let endpoint: Endpoint<[Post]> = APIEnvironment.GET("/posts")
        store
            .send(endpoint.setQueryValue("1", forKey: "id"))
            .done { posts in
                XCTAssertEqual(posts.count, 1)
                expectation.fulfill()
            }.catch { error in
                XCTAssert(false, "\(error)")
            }
        waitForExpectations(timeout: 1, handler: nil)
    }
}
