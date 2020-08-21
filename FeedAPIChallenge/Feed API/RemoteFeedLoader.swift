//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
	private let url: URL
	private let client: HTTPClient

    typealias Result = FeedLoader.Result
	
	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}
		
	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}
	
	public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            switch result {
            case let .success((data, response)):
                do {
                    let feedImages = try FeedImageMapper.map(data, from: response)
                    completion(.success(feedImages))
                } catch {
                    completion(.failure(error))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
