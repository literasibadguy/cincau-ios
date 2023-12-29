//
//  bestokApp.swift
//  bestok
//
//  Created by Firas Rafislam on 25/12/2023.
//

import SwiftUI
import SwiftData

@main
struct bestokApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    

    var body: some Scene {
        WindowGroup {
            HomeView()
            
   
        }
        .modelContainer(sharedModelContainer)
        
        #if os(visionOS)
        // Defines an immersive space to present a destination in which to watch the video.
        ImmersiveSpace(for: String.self) { $destination in
            SphereView()
        }
        // Set the immersion style to progressive, so the user can use the crown to dial in their experience.
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
        #endif
            }
}

@available(visionOS, unavailable)
class OrientationTracker: ObservableObject {
    var deviceMajorAxis: CGFloat = 0
    func setDeviceMajorAxis() {
        let bounds = UIScreen.main.bounds
        let height = max(bounds.height, bounds.width) /// device's longest dimension
        let width = min(bounds.height, bounds.width)  /// device's shortest dimension
        let orientation = UIDevice.current.orientation
        deviceMajorAxis = (orientation == .portrait || orientation == .unknown) ? height : width
    }
}

