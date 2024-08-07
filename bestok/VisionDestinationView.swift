//
//  VisionDestinationView.swift
//  bestok
//
//  Created by Firas Rafislam on 25/01/2024.
//

import SwiftUI

struct VisionDestinationView: View {
    
    @ObservedObject private var tiktokTranslator = TiktokTranslator()
    
    @State private var tiktokUrl: String = ""
    
    var body: some View {
        ZStack {
            Image("winter_scene")
            
            VStack(alignment: .center) {
                
                
                
                Spacer()
                
                VStack {
                    Text("Welcome your first entertainment")
                    Text("TikTok Videos based on Vision OS").font(.system(size: 24))
                }
                
                Spacer()
                
                Text("Please add your url here")
                HStack {
                    Spacer()
                    TextField("show your url here", text: $tiktokUrl).padding()
                    Spacer()
                }
                
                Spacer()
                
                Button(action: {
                    Task {
                        do {
                            try await tiktokTranslator.translateForVideoData(tiktokUrl)
                        } catch {
                            tiktokUrl = "Something error"
                        }
                    }
                }, label: {
                    Text("Download Complete")
                })
                
                Spacer()
            }
        }
    }
}

#Preview {
    VisionDestinationView()
}
