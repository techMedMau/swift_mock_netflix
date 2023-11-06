//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Maureen Chang on 2023/11/6.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
