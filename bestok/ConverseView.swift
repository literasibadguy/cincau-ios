//
//  ConverseView.swift
//  bestok
//
//  Created by Firas Rafislam on 25/12/2023.
//

import SwiftUI

enum ConverseStatus: Equatable {
    case havent_converse
    case conversed(URL)
    case error
}

class ConverseViewModel: ObservableObject {
    @Published var state: ConverseStatus
    
    init(state: ConverseStatus) {
        self.state = state
    }
}

struct ConverseView: View {
    
    @State private var completed = false
    @State private var tiktokUrl = ""
    
    @ObservedObject private var converseViewModel: ConverseViewModel = ConverseViewModel(state: .havent_converse)
    
    var ConverseButton: some View {
        Button("Download Video") {
            converse()
        }
    }
    
    var body: some View {
        Group {
            switch converseViewModel.state {
            case .havent_converse:
                VStack(alignment: .center) {
                    Spacer()
                    TextField("Tiktok Url", text: $tiktokUrl)
                    Text("Copy your video Url Tiktok")
                    Spacer()
                    ConverseButton
                }
            case .conversed(let tiktokUrl):
                VStack(alignment: .leading) {
                    ShortVideoPlayer(url: tiktokUrl, video_size: .constant(nil), controller: VideoController())
                }
            case .error:
                VStack(alignment: .leading) {
                    Text("Something error here")
                }
            }
        }
    }
    
    func converse() {
        Task {
            let res = await converse_tiktok(linkUrl: tiktokUrl)
            DispatchQueue.main.async {
                self.converseViewModel.state = res
                self.completed = true
            }
        }
    }
}

func converse_tiktok(linkUrl: String) async -> ConverseStatus {
    let translator = TiktokTranslator()
    
    let conversed_tiktok = try? await translator.translateForVideoUrl(linkUrl, from: "", to: "")
    
    guard let conversed_tiktok else {
        return .error
    }
    
    return .conversed(conversed_tiktok)
}

#Preview {
    ConverseView()
}
