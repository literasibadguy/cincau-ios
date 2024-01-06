//
//  ProfileFeedView.swift
//  bestok
//
//  Created by Firas Rafislam on 05/01/2024.
//

import SwiftUI

struct ProfileFeedView: View {
    
    @StateObject private var tiktokTranslator: TiktokTranslator = TiktokTranslator()
    
    var body: some View {
        VStack {
            Text("Kang Seulgi")
            LazyVGrid(columns: [.init(.fixed(40))]) {
                
            }
        }.onAppear {
            Task {
                let posts = try await tiktokTranslator.translateforUserPosts("fujiian")
            }
        }
        
    }
}

#Preview {
    ProfileFeedView()
}
