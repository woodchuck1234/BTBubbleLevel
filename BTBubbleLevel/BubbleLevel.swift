/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct BubbleLevel: View {
    @EnvironmentObject var detector: TiltDetector
    @EnvironmentObject var settings: Settings

    var eq = EQLevelers()

    //let range = Double.pi
    let range = 90.0
    let levelSize: CGFloat = 200

    // X & Y Position - fraction of entire range, full left - 0.0, flat - 0.5, full right - 1.0
    
    var bubbleXPosition: CGFloat {
        
        let zeroBasedRoll = detector.roll + range / 2
        let rollAsFraction = zeroBasedRoll / range
        //print("X: \(detector.roll) zeroed roll: \(zeroBasedRoll) as fraction \(rollAsFraction)")
        return CGFloat(rollAsFraction) * levelSize
    }

    var bubbleYPosition: CGFloat {
        let zeroBasedPitch = detector.pitch + range / 2
        let pitchAsFraction = zeroBasedPitch / range
        //print("Y: \(detector.pitch) zeroed pitch \(zeroBasedPitch) as a fraction \(pitchAsFraction)")
        return CGFloat(pitchAsFraction) * levelSize
    }

    var verticalLine: some View {
        Rectangle()
            .frame(width: levelSize, height: 1)
            //.position(x: levelSize / 2, y: levelSize / 2)
    }

    var horizontalLine: some View {
        Rectangle()
            .frame(width: 1, height: levelSize)
            //.position(x: levelSize / 2, y: levelSize / 2)
    }

    @GestureState var isRFPress = false
    @State var completedLongPressRF = false
    var raise_front: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating($isRFPress) { currentState, gestureState,
                    transaction in
                gestureState = currentState
                eq.lower_front()
                //transaction.animation = Animation.easeIn(duration: 2.0)
            }
            .onEnded { finished in
                self.completedLongPressRF = finished
            }
    }
    @GestureState var isLFPress = false
    @State var completedLongPressLF = false
    var lower_front: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating($isLFPress) { currentState, gestureState,
                transaction in
                gestureState = currentState
                eq.raise_front()
                //transaction.animation = Animation.easeIn(duration: 2.0)
            }
            .onEnded { finished in
                self.completedLongPressLF = finished
            }
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let levelCenter = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                
                Circle() // Outer circle
                    .foregroundColor(Color.secondary.opacity(0.25))
                    .frame(width: levelSize, height: levelSize)
                    .position(levelCenter)
                    .overlay(
                        ZStack {
                            // inner bubble circle
                            if detector.connected {
                                Circle()
                                    .foregroundColor(.green)
                                    .frame(width: 50, height: 50)
                                    .position(
                                        x: levelCenter.x + bubbleXPosition - levelSize / 2,
                                        y: levelCenter.y + bubbleYPosition - levelSize / 2
                                    )
                            } else {
                                Circle()
                                    .foregroundColor(.red)
                                    .frame(width: 50, height: 50)
                                    .position(
                                        x: levelCenter.x + bubbleXPosition - levelSize / 2,
                                        y: levelCenter.y + bubbleYPosition - levelSize / 2
                                    )
                            }
                            BusView(levelCenter: levelCenter, geoSize: geo.size)
                            
                            Circle()
                                .stroke(lineWidth: 0.5)
                                .frame(width: 51, height: 51)
                                .position(levelCenter)
                            
                            
                            verticalLine
                                .position(x: levelCenter.x, y: levelCenter.y )
                            horizontalLine
                                .position(x: levelCenter.x, y: levelCenter.y)
                        }
                    )
                    .background(
                        Image("RVOutline")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 1.2, height: geo.size.height * 1.9) // Adjust the width and height as desired
                            .position(levelCenter)
                    )
            }
        }
    }

}

struct BubbleLevel_Previews: PreviewProvider {
    @StateObject static var tiltDetector = TiltDetector()
    @StateObject static var settings = Settings()

    static var previews: some View {
        BubbleLevel()
            .environmentObject(tiltDetector)
            .environmentObject(settings)
    }
}
