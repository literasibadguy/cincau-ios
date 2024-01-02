//
//  DownloadActionSheetView.swift
//  bestok
//
//  Created by Firas Rafislam on 31/12/2023.
//

import SwiftUI

struct DownloadActionSheetView: View {
    
    let videoData: TiktokData
    let downloadAction: () -> Void
    
    @State private var sheetHeight: CGFloat = 360
    
    
    
    var body: some View {
            ZStack {
                
                Blur().background {
                    Color.clear
                }
                    .ignoresSafeArea()
                
                VStack {
                    
                    Text("Downloads").font(karrik_font(.title, font_size: 1)).foregroundStyle(.white)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        DownloadItemView(title: "Download with Watermark", size: videoData.wmSize, itemAction: downloadAction)
                        DownloadItemView(title: "Download 1080p", size: videoData.hdSize, itemAction: downloadAction)
                        DownloadItemView(title: "Download 720p", size: videoData.size, itemAction: downloadAction)
                        
                    }.padding().frame(height: 360).overlay {
                        GeometryReader { geometry in
                            Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
                        }
                    }.onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                            sheetHeight = newHeight
                }.presentationDetents([.height(sheetHeight)])
                }
                                           
            }.navigationTitle("Downloads").navigationBarTitleDisplayMode(.inline).background(.clear)
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


struct  DownloadItemView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let title: String
    let size: Int
    
    let itemAction: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                    Text(title).foregroundStyle(.windowBackground)
                    
                    Text(String(size)).foregroundStyle(.windowBackground)
                    
            }.font(karrik_font(.normal, font_size: 1))
            
            Spacer()
        }.padding().background {
            RoundedRectangle(cornerRadius: 12.0).stroke(Color.white, lineWidth: 1)
        }.onTapGesture {
            itemAction()
            dismiss()
        }
           
    }
    

}

#Preview {
    DownloadActionSheetView(videoData: .sample, downloadAction: {})
}
