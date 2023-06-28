/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct OrientationDataView: View {
    @EnvironmentObject var detector: TiltDetector
    @EnvironmentObject var ble: BLEConnection

    var rollString: String {
        String(format: "%.1f", detector.roll)

        
    }

    var pitchString: String {
        String(format: "%.1f", detector.pitch)
    }

    var body: some View {
        HStack {
            Text("Roll: " + rollString)
                .font(.system(.body, design: .monospaced))
            Text("Pitch: " + pitchString)
                .font(.system(.body, design: .monospaced))
        }
    }
}

struct OrientationDataView_Previews: PreviewProvider {
    @StateObject static private var tiltDetector = TiltDetector()
    
    static var previews: some View {
        OrientationDataView()
            .environmentObject(tiltDetector)
    }
}
