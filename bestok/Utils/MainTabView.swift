//
//  MainTabView.swift
//  bestok
//
//  Created by Firas Rafislam on 06/01/2024.
//

import SwiftUI

enum MainMenu: String {
    case trending
    case home
    case support
}

struct TabButton: View {
    let mainmenu: MainMenu
    let img: String
    let action: (MainMenu) -> ()
    var body: some View {
        ZStack(alignment: .center) {
           Tab
        }
    }
    
    var Tab: some View {
        Button(action: {
            action(mainmenu)
        }) {
            Image(systemName: img).contentShape(Rectangle()).font(.subheadline)
        }.foregroundColor(.primary)
    }
}

struct MainTabView: View {
    let action: (MainMenu) -> ()
    var body: some View {
        VStack {
            Divider()
            HStack {
                TabButton(mainmenu: .trending, img: "water.waves", action: action)
                TabButton(mainmenu: .home, img: "house.fill", action: action)
                TabButton(mainmenu: .support, img: "hand.thumbsup", action: action)
            }
        }
    }
}

