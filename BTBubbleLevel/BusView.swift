//
//  BusView.swift
//  BubbleLevel (iOS)
//
//  Created by Matt Tooley on 5/16/22.
//

import SwiftUI

extension Double {
    var asDegrees: Double { return self * 180 / .pi}
    var asRadians: Double { return self * .pi / 180}
}

// alpha is roll
// beta is pitch, dX is distance to corners A,B,C,D
// We calculate the center from the Length and Width

struct BusView: View {
    @EnvironmentObject var detector: TiltDetector
    @EnvironmentObject var ble: BLEConnection
    @EnvironmentObject var settings: Settings
    let levelCenter : CGPoint
    let geoSize: CGSize
    
    var rollString: String {
        //String(tilt.x)
        detector.roll.describeAsFixedLengthString()
        //String(ble.imuRoll ?? 0)
    }

    var pitchString: String {
        //String(tilt.y)
        detector.pitch.describeAsFixedLengthString()
        //String(ble.imuPitch ?? 0)
    }
    
    // Right Triangle --> Tan(alpha) = Opposite side / Adjacent side
    // Therefore, Opposite = Tan(alpha) * Adjacent

    func distanceToCorner() -> Double {
        // Calculate the distance from the center of the rectangle to the corners
        let halfLength = settings.rvLength / 2.0
        let halfWidth = settings.rvWidth / 2.0

        // Calculate the hypotenuse using the Pythagorean theorem
        let hypotenuse = sqrt(pow(halfLength, 2) + pow(halfWidth, 2))
        
        return hypotenuse
    }
    // Rear //LEFT
    var drString : String {
        let dA = distanceToCorner()
        let h = (-dA * (tan(detector.pitch * .pi / 180.0) + tan(detector.roll * .pi / 180.0) ))
        let stringFloat = String(format: "%.1f", h)

        return stringFloat+"\""
    }
    // REAR //RIGHT
    var prString : String {
        let dB = distanceToCorner()
        let h = (dB * (tan(detector.roll * .pi / 180.0) - tan(detector.pitch * .pi / 180.0)))
        let stringFloat = String(format: "%.1f", h)
        
        return stringFloat+"\""
    }
    // Front // Lef-
    var pfString : String {
        let dD = distanceToCorner()
        let h = (dD * (tan(detector.pitch * .pi / 180.0) + tan(detector.roll * .pi / 180.0)))
        let stringFloat = String(format: "%.1f", h)

        return stringFloat+"\""
    }

    // FRONT // RIGHT
    var dfString : String {
        let dC = distanceToCorner()
        print("DC: \(dC)  \(tan(detector.roll * .pi / 180.0)) \(tan(detector.pitch * .pi / 180.0) )")
        let h = (-dC * (tan(detector.roll * .pi / 180.0) - tan(detector.pitch * .pi / 180.0) ) )
        let stringFloat = String(format: "%.1f", h)

        return stringFloat+"\""
    }

    
    var body: some View {
        ZStack{
            
            Text(dfString)
                .font(.system(.body, design: .monospaced))
                .position(x: levelCenter.x - geoSize.width/2 + 30, y: levelCenter.y - geoSize.height/2 + 30)
            Text(pfString)
                .font(.system(.body, design: .monospaced))
                .position(x: levelCenter.x + geoSize.width/2 - 30, y: levelCenter.y - geoSize.height/2 + 30)

            Text(drString)
                .font(.system(.body, design: .monospaced))
                .position(x: levelCenter.x - geoSize.width/2 + 30, y: levelCenter.y + geoSize.height/2 - 30)

            Text(prString)
                .font(.system(.body, design: .monospaced))
                .position(x: levelCenter.x + geoSize.width/2 - 30, y: levelCenter.y + geoSize.height/2 - 30)

            
        }
    }
}

struct BusView_Previews: PreviewProvider {
    @StateObject static var tiltDetector = TiltDetector()
    static var previews: some View {
        GeometryReader { geo in
            BusView(levelCenter: CGPoint(x: geo.size.width / 2, y: geo.size.height / 2), geoSize: geo.size)
                .environmentObject(tiltDetector)
        }
    }
}
