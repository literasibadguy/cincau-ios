//
//  DownloadActionSheetView.swift
//  bestok
//
//  Created by Firas Rafislam on 31/12/2023.
//

import SwiftUI

struct DownloadActionSheetView: View {
    
    let downloadAction: () -> Void
    
    @State private var sheetHeight: CGFloat = 360
    
    @State private var wmSize: Int = 0
    @State private var hdSize: Int = 0
    @State private var size: Int = 0
    
    init(videoData: TiktokData, downloadAction: @escaping () -> Void) {
        self.wmSize = videoData.wmSize
        self.hdSize = videoData.hdSize
        self.downloadAction = downloadAction
    }
    
    
    
    var body: some View {
            ZStack {
                
                Blur().background {
                    Color.clear
                }
                    .ignoresSafeArea()
                
                VStack(spacing: 1) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Downloads").font(karrik_font(.title, font_size: 1)).foregroundStyle(.white)
                        DownloadItemView(title: "Download with Watermark", size: self.wmSize, itemAction: downloadAction)
                        DownloadItemView(title: "Download 1080p", size: self.hdSize, itemAction: downloadAction)
                        DownloadItemView(title: "Download 720p", size: self.size, itemAction: downloadAction)
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
                    Text(title)
                    
                    Text(formatSizeFile(size))
                    
            }.font(karrik_font(.normal, font_size: 1))
            
            Spacer()
        }.padding().background {
            RoundedRectangle(cornerRadius: 12.0).stroke(Color.white, lineWidth: 1)
        }.onTapGesture {
            itemAction()
            dismiss()
        }
           
    }
    
    private func formatSizeFile(_ byteCount: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(byteCount))
    }

}

#Preview {
    DownloadActionSheetView(videoData: .sample, downloadAction: {})
}
