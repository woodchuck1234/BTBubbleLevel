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

let b = 5 // length of side

struct BusView: View {
    @EnvironmentObject var detector: TiltDetector
    @EnvironmentObject var ble: BLEConnection
    
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

    var dfString : String {
        //let h = tan(detector.roll)*10
        let h = Double(b) / cos(detector.roll)
        let stringFloat = String(format: "%.1f", h)

        return stringFloat+"\""
    }
    
    var pfString : String {
        let h = tan(detector.roll)*10
        let stringFloat = String(format: "%.1f", h)

        return stringFloat+"\""
    }
    var drString : String {
        let h = tan(detector.roll)*10
        let stringFloat = String(format: "%.1f", h)

        return stringFloat+"\""
    }
    var prString : String {
        let h = tan(detector.roll)*10
        let stringFloat = String(format: "%.1f", h)

        return stringFloat+"\""
    }
    
    var body: some View {
        ZStack{
            Text(dfString)
                .font(.system(.body, design: .monospaced))
                .position(x: 100, y: 50)
            Text(pfString)
                .font(.system(.body, design: .monospaced))
                .position(x: 275, y: 50)
            Text(drString)
                .font(.system(.body, design: .monospaced))
                .position(x: 100, y: 400)
            Text(prString)
                .font(.system(.body, design: .monospaced))
                .position(x: 275, y: 400)
        }
    }
}

struct BusView_Previews: PreviewProvider {
    @StateObject static var tiltDetector = TiltDetector()
    static var previews: some View {
        BusView().environmentObject(tiltDetector)
    }
}
