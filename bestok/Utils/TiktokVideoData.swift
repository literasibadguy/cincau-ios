//
//  TiktokVideoData.swift
//  bestok
//
//  Created by Firas Rafislam on 25/12/2023.
//

import Foundation

struct TiktokData: Decodable, Identifiable {
    let id: String
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
        case id
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


    
    static let sample = TiktokData(id: "", region: "", title: "#paidpartnership@alolis.id Bakalan stock di rumah terus nih buat Gala!  Yuk borong di Alfamart terdekat! Dapetin hadiahnya!! #UnlockYourFantasy #MainBarengAlolis #AlolisBagiBagiRejeki #AlolisDiAlfamart #alolisransbagirejeki", cover: URL(string: "https://p16-sign-sg.tiktokcdn.com/obj/tos-alisg-p-0037/faaa1a1773414683a10c438f23f6ff82_1696286170?lk3s=d05b14bd&x-expires=1703815200&x-signature=sUVWuPWv0vuOe8HGqV1Stxr%2F38Q%3D&s=AWEME_DETAIL&se=false&sh=&sc=dynamic_cover&l=20231228022518D6F1E1EA5A4F231A3A5E")!, originCover: URL(string: "https://p16-sign-sg.tiktokcdn.com/tos-alisg-p-0037/193d78c80c5d44a1beaa42d233e728d8_1696286169~tplv-tiktokx-360p.jpeg?lk3s=d05b14bd&x-expires=1703815200&x-signature=KX%2BGtiU6r3mUb%2FoNjoc%2BKe8amXQ%3D&s=AWEME_DETAIL&se=false&sh=&sc=feed_cover&l=20231228022705F85EB2C3638AE51D77D3")!, duration: 0, play: URL(string: "https://v16m-default.akamaized.net/51ab948a6e76b8642d035d5139aa7539/658f1673/video/tos/useast2a/tos-useast2a-ve-0068-euttp/okKImtgrTDuWYD2JAYgyIjQ8b5IflEGetnZjfe/?a=0&ch=0&cr=0&dr=0&lr=all&cd=0%7C0%7C0%7C0&cv=1&br=1374&bt=687&bti=OUBzOTg7QGo6OjZAL3AjLTAzYCMxNDNg&cs=0&ds=6&ft=XE5bCqT0m7jPD12yF1yR3wUTV3yKMeF~O5&mime_type=video_mp4&qs=0&rc=NTloOmQ8ZzY0ZGlpOGk1M0BpM3A6OWY6Zmw7bTMzZjczM0BgNTQ0Li5iXjUxYy5eMy4zYSNqYW1qcjRncHJgLS1kMWNzcw%3D%3D&l=20231229125628FBBBE616C738DF89859C&btag=e00088000")!, wmPlay: URL(string: "https://v16m-default.akamaized.net/6f04f450b524383ccee567c009b9e6d5/658d3168/video/tos/alisg/tos-alisg-pve-0037c001/owkjoIlEzYALaARgwhtdA0Q6pfA1EyACxGjIyb/?a=0&ch=0&cr=0&dr=0&lr=all&cd=0%7C0%7C0%7C0&cv=1&br=5630&bt=2815&bti=OUBzOTg7QGo6OjZAL3AjLTAzYCMxNDNg&cs=0&ds=3&ft=XE5bCqT0m7jPD12Fr6yR3wUTV3yKMeF~O5&mime_type=video_mp4&qs=0&rc=ZmlpaTQ2NzpnOzY6NWc0N0BpajM1Zzk6ZmxubjMzODczNEA2MTFhXjYwXzAxMjIwMGEvYSNlZ18tcjRvX2FgLS1kMS1zcw%3D%3D&l=20231228022705F85EB2C3638AE51D77D3&btag=e00088000")!, hdPlay: URL(string: "https://v16m-default.akamaized.net/4bb98340f12b250164ab58b9228e7f9b/658d9081/video/tos/alisg/tos-alisg-pv-0037c001/d3e58c60c8fa40589fc5ee88de09ecdc/?a=0&ch=0&cr=0&dr=0&lr=all&cd=0%7C0%7C0%7C1&cv=1&br=5858&bt=2929&bti=OTg7QGo5QHM6OjZALTAzYCMvcCMxNDNg&ds=3&ft=XE5bCqT0m7jPD12V8EyR3wUTV3yKMeF~O5&mime_type=video_mp4&qs=13&rc=anZzZjQ6ZnY3azMzODczNEBpanZzZjQ6ZnY3azMzODczNEAuYy9ecjQwMTZgLS1kMS1zYSMuYy9ecjQwMTZgLS1kMS1zcw%3D%3D&l=20231228091249AE33823E9F16843C47B6&btag=e00048000")!, size: 0, wmSize: 0, hdSize: 0, music: URL(string: "https://sf16-ies-music-va.tiktokcdn.com/obj/ies-music-ttp-dup-us/7055516784715156270.mp3")!, musicInfo: .init(id: "", title: "What Happen", play: URL(string: "https://sf16-ies-music-va.tiktokcdn.com/obj/ies-music-ttp-dup-us/7055516784715156270.mp3")!, cover: URL(string: "https://p16-sign-va.tiktokcdn.com/tos-maliva-avt-0068/7584ceb18fa6e009470c5e6669b3272f~c5_1080x1080.jpeg?lk3s=45126217&x-expires=1703815200&x-signature=hMhXK9XSPcY4jAgjrSxr5xs7eGI%3D")!, author: "Original", original: false, duration: 0, album: ""), playCount: 0, diggCount: 0, commentCount: 0, shareCount: 0, downloadCount: 0, collectCount: 0, createTime: 0, anchors: nil, commerceInfo: .init(advPromotable: false, auctionAdInvited: false, brandedContentType: 0, withCommentFilterWords: false), commercialVideoInfo: "", author: .init(id: "", uniqueId: "dananufussi_", nickname: "Dana Nufussi", avatar: URL(string: "https://p16-sign-sg.tiktokcdn.com/tos-alisg-avt-0068/f5646c34230ffa944e471130891a67c9~c5_300x300.jpeg?lk3s=45126217&x-expires=1703815200&x-signature=I53V0kO2bgAmjplWxDcvojGeHYE%3D")!))
}

struct Anchor: Decodable {
    let id: String
    let uniqueId: String
    let nickname: String
    let avatar: URL

    enum CodingKeys: String, CodingKey {
        case id
        case uniqueId = "unique_id"
        case nickname
        case avatar
    }
}

struct MusicInfo: Decodable, Equatable, Hashable {
    let id: String
    let title: String
    let play: URL
    let cover: URL
    let author: String
    let original: Bool
    let duration: Int
    let album: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case play
        case cover
        case author
        case original
        case duration
        case album
    }
}

struct CommerceInfo: Decodable {
    let advPromotable: Bool
    let auctionAdInvited: Bool
    let brandedContentType: Int
    let withCommentFilterWords: Bool

    enum CodingKeys: String, CodingKey {
        case advPromotable = "adv_promotable"
        case auctionAdInvited = "auction_ad_invited"
        case brandedContentType = "branded_content_type"
        case withCommentFilterWords = "with_comment_filter_words"
    }
}

struct Author: Decodable, Identifiable, Hashable {
    let id: String
    let uniqueId: String
    let nickname: String
    let avatar: URL

    enum CodingKeys: String, CodingKey {
        case id
        case uniqueId = "unique_id"
        case nickname
        case avatar
    }
}
