//
//  TrendVideoData.swift
//  bestok
//
//  Created by Firas Rafislam on 29/12/2023.
//

import Foundation

struct TrendVideo: Decodable {
    let video_id: String
    let region: String
    let title: String
    let cover: URL
    let originCover: URL
    let duration: Int
    let play: URL
    let wmPlay: URL
    let hdPlay: URL
    let size: Int
    let wmSize: Int
    let hdSize: Int
    let music: URL
    let musicInfo: MusicInfo
    let playCount: Int
    let diggCount: Int
    let commentCount: Int
    let shareCount: Int
    let downloadCount: Int
    let collectCount: Int
    let createTime: Int
    let anchors: [Anchor]?
    let commerceInfo: CommerceInfo
    let commercialVideoInfo: String
    let author: Author
    
    enum CodingKeys: String, CodingKey {
        case video_id
        case region
        case title
        case cover
        case originCover = "origin_cover"
        case duration
        case play
        case wmPlay = "wmplay"
        case hdPlay = "hdplay"
        case size
        case wmSize = "wm_size"
        case hdSize = "hd_size"
        case music
        case musicInfo = "music_info"
        case playCount = "play_count"
        case diggCount = "digg_count"
        case commentCount = "comment_count"
        case shareCount = "share_count"
        case downloadCount = "download_count"
        case collectCount = "collect_count"
        case createTime = "create_time"
        case anchors
        case commerceInfo = "commerce_info"
        case commercialVideoInfo = "commercial_video_info"
        case author
    }

}
