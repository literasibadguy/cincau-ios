//
//  TikTokTranslator.swift
//  bestok
//
//  Created by Firas Rafislam on 25/12/2023.
//

import Foundation


public struct TiktokTranslator {
    private let session = URLSession.shared
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    func translateForVideoUrl(_ url: String, from sourceLanguage: String, to targetLanguage: String) async throws -> URL {
    

        let url = try makeURL("https://tikwm.com", path: "/api", videoUrl: url)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:121.0) Gecko/20100101 Firefox/121.0", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")


        
        /*
        struct RequestBody: Encodable {
            let text: [String]
            let source_lang: String
            let target_lang: String
        }
        let body = RequestBody(text: [text], source_lang: sourceLanguage.uppercased(), target_lang: targetLanguage.uppercased())
        request.httpBody = try encoder.encode(body)
         */
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
