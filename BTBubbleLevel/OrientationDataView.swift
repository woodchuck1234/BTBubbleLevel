/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct OrientationDataView: View {
    @EnvironmentObject var detector: TiltDetector
    @EnvironmentObject var ble: BLEConnection

    var rollString: String {
        //String(tilt.x)
        detector.roll.describeAsFixedLengthString()

        
    }

    var pitchString: String {
        //String(tilt.y)
        detector.pitch.describeAsFixedLengthString()
    }

    var body: some View {
        VStack {
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
