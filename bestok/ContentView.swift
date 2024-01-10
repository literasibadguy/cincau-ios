//
//  ContentView.swift
//  bestok
//
//  Created by Firas Rafislam on 25/12/2023.
//

import SwiftUI
import SwiftData
import RealityKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    

    
    @SceneStorage("ContentView.selected_mainmenu") var selected_menu: MainMenu = .home
    let customFont = Font.custom("Karrik-Regular", fixedSize: 12)

    func MainContent() -> some View {
        VStack {
            switch selected_menu {
            case .trending:
                TrendingFeedView()
            case .home:
                HomeView()
            case .support:
               DonateView()
            }
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationStack {
                TabView {
                    VStack {
                        MainContent()
                    }
                }.tabViewStyle(.page(indexDisplayMode: .never))
            }.navigationViewStyle(.stack)
            
            MainTabView(action: switch_mainmenu).padding([.bottom], 8).background(Color(uiColor: .systemBackground).ignoresSafeArea())
        }
    }
    
    func switch_mainmenu(_ mainmenu: MainMenu) {
        self.selected_menu = mainmenu
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
