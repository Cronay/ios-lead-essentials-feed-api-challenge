//
//  FeedImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Cronay on 21.08.20.
//  Copyright © 2020 Essential Developer Ltd. All rights reserved.
//

import Foundation

class FeedImageMapper {
    private struct Root: Decodable {
        let items: [Item]
    }

    private struct Item: Decodable {
        public let id: UUID
        public let description: String?
        public let location: String?
        public let url: URL

        private enum CodingKeys: String, CodingKey {
            case id = "image_id"
            case description = "image_desc"
            case location = "image_loc"
            case url = "image_url"
        }

        var item: FeedImage {
            return FeedImage(id: id, description: description, location: location, url: url)
        }
    }

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [FeedImage] {
        guard response.statusCode == 200,
            let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return root.items.map { $0.item }
    }
}