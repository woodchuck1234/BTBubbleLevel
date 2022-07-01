
import SwiftUI

@main
struct BubbleLevelApp: App {
    //@StateObject private var motionDetector = MotionDetector(updateInterval: 0.01)
    //@StateObject private var ble = BLEManager()
    @StateObject var tiltDetector = TiltDetector()

    var body: some Scene {
        WindowGroup {
            LevelView()
                .environmentObject(tiltDetector)

        }
    }
}
