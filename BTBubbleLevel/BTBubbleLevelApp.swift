import SwiftUI

let settings = Settings()

@main
struct BubbleLevelApp: App {
    //@StateObject private var motionDetector = MotionDetector(updateInterval: 0.01)
    //@StateObject private var ble = BLEManager()
    //@StateObject var settings = Settings()

    var body: some Scene {
        WindowGroup {
            LevelView(settings: settings)
                .environmentObject(TiltDetector(settings: settings))
                .environmentObject(settings)
        }
    }
}
