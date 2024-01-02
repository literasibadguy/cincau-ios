//
//  TikTokTranslator.swift
//  bestok
//
//  Created by Firas Rafislam on 25/12/2023.
//

import Foundation
import UIKit
import Photos

struct TrendingFeed: Decodable {
    let code: Int
    let msg: String
    let processed_time: Double
    let datas: [TiktokData]
    
    enum CodingKeys: String, CodingKey {
        case code
        case msg
        case processed_time
        case datas = "data"
    }
    
    struct TrendVideo: Decodable {
        let video_id: String
        let region: String
    }
}

public class TiktokTranslator: ObservableObject {
    private let session = URLSession.shared
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    @Published var tiktokUrl = ""
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(clipboardChanged),
                                                       name: UIPasteboard.changedNotification, object: nil)
    }
    
    func translateForVideoData(_ url: String) async throws -> TiktokData {

        let url = try makeURL("https://tikwm.com", path: "/api", videoUrl: url)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:121.0) Gecko/20100101 Firefox/121.0", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        struct Response: Decodable {
            let videoData: TiktokData
            
            enum CodingKeys: String, CodingKey {
                case videoData = "data"
            }
        }

        let response: Response = try await decodedData(for: request)
        return response.videoData
    }
    
    func translateForVideoUrl(_ url: String, from sourceLanguage: String, to targetLanguage: String) async throws -> URL {
    

        let url = try makeURL("https://tikwm.com", path: "/api", videoUrl: url)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:121.0) Gecko/20100101 Firefox/121.0", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")


        struct Response: Decodable {
            let videoData: TiktokData
            
            enum CodingKeys: String, CodingKey {
                case videoData = "data"
            }
        }
        struct DeepLTranslations: Decodable {
            let detected_source_language: String
            let text: String
        }

        let response: Response = try await decodedData(for: request)
        return response.videoData.hdPlay
    }
    
    private func trendingURL(_ baseUrl: String, path: String, regionUrl: String) throws -> URL {
        guard var components = URLComponents(string: baseUrl) else {
            throw URLError(.badURL)
        }
        let queryItems = [URLQueryItem(name: "url", value: regionUrl), URLQueryItem(name: "hd", value: "1"), URLQueryItem(name: "region", value: regionUrl), URLQueryItem(name: "count", value: "10"), URLQueryItem(name: "cursor", value: "0"), URLQueryItem(name: "web", value: "1")]
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return url
    }
    
    private func download() {
        
        let videoUrl = "http://7xp99e.com2.z0.glb.qiniucdn.com/2/video_article/6351A5E8_7F6C_4717_B91D_FE750634B5D5.mp4"
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
        let destPath = NSString(string: documentPath).appendingPathComponent("video.mp4") as String
        
        if FileManager.default.fileExists(atPath: destPath) {
            print("file already exist at \(destPath)")
//            self.playVideo(NSURL(fileURLWithPath: destPath))
            return
        }
        
        
        let downloadTask = URLSession.shared.downloadTask(with: URL(string: videoUrl)!) { (location, response, error) in
            guard let location else { return }
            
            UISaveVideoAtPathToSavedPhotosAlbum(location.absoluteString, nil, nil, nil)
            
        }
        downloadTask.resume()
        
        switch downloadTask.state {
        case .running: break
            
        case .suspended: break
            
        case .canceling: break
            
        case .completed: break
        }
    }
    

    private func makeURL(_ baseUrl: String, path: String, videoUrl: String) throws -> URL {
        guard var components = URLComponents(string: baseUrl) else {
            throw URLError(.badURL)
        }
        let queryItems = [URLQueryItem(name: "url", value: videoUrl), URLQueryItem(name: "hd", value: "1")]
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return url
    }
    
    private func decodedData<Output: Decodable>(for request: URLRequest) async throws -> Output {
        let data = try await session.data(for: request)
        let result = try decoder.decode(Output.self, from: data)
        return result
    }

    @objc private func clipboardChanged(){
           let pasteboardString: String? = UIPasteboard.general.string
           if let theString = pasteboardString {
               if theString.contains("tiktok.com") {
                   tiktokUrl = theString
               }
           }
       }
}

private extension URLSession {
    func data(for request: URLRequest) async throws -> Data {
        var task: URLSessionDataTask?
        let onCancel = { task?.cancel() }
        return try await withTaskCancellationHandler(
            operation: {
                try await withCheckedThrowingContinuation { continuation in
                    task = dataTask(with: request) { data, _, error in
                        guard let data = data else {
                            let error = error ?? URLError(.badServerResponse)
                            print(error)
                            return continuation.resume(throwing: error)
                        }
                        continuation.resume(returning: data)
                    }
                    task?.resume()
                }
            },
            onCancel: { onCancel() }
        )
    }
}
