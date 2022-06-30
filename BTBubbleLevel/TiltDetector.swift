//
//  TiltDetector.swift
//  BubbleLevel (iOS)
//
//  Created by Matt Tooley on 5/10/22.
//
import Foundation

class TiltDetector: ObservableObject {
    private var bleManager: BLEManagable = BLEManager()
    
    @Published var x = 0.0
    @Published var y = 0.0
    
    @Published var pitch: Double = 0
    @Published var roll: Double = 0
    @Published var zAcceleration = 0
    
    @Published var connected: Bool = false

    
    private var timer = Timer()
    private var updateInterval: TimeInterval
    
    init() {
        self.updateInterval = 0.01
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in self.updateTiltData()
            }

    }
    
    struct Tilt: Codable {
        var x: Double?
        var y: Double?
    }
    
    func updateTiltData() {
        //print("updateTiltData()")
        var dataString = bleManager.getData()
        //print("data: \(dataString)")
        if bleManager.connected() {
            connected = true
        }
        else {
            connected = false
        }
        
        if !dataString.isEmpty {
            //print("dataString: \(dataString)")
            let tiltarray = dataString.components(separatedBy: " ")
            let x = tiltarray[0]
            let y = tiltarray[1]
            roll = Double(x)!
            pitch = Double(y)!
            //let data = dataString.data(using: .utf8)!
            //let decoder = JSONDecoder()
            //do {
            //    let tilt = try decoder.decode(Tilt.self, from: data)
            //    if tilt.x != nil {
            //        roll = tilt.x ?? 0.0
            //        print("roll: \(roll)")
            //    }
            //    if tilt.y != nil {
            //        pitch = tilt.y ?? 0.0
            //        print("pitch \(pitch)")
            //    }
            //    //print("roll: \(roll)  pitch: \(pitch)")
            //} catch {
            //    print(error)
            //}
            
        }
        
    }
    
    func stop() {
        timer.invalidate()
    }
    
    deinit {
        stop()
    }
}

extension TiltDetector: BLEManagerDelegate {
    func bleManagerDidConnect(_ manager: BLEManagable) {

        
    }
    func bleManagerDidDisconnect(_ manager: BLEManagable) {

    }
    
    struct TiltJson: Codable {
        var x: Double
        var y: Double
    }
    
    func bleManager(_ manager: BLEManagable, receivedDataString dataString: String) {
        
        print("recivedDataString")
        let data = dataString.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let tilt = try decoder.decode(TiltJson.self, from: data)
            x = tilt.x
            y = tilt.y
        } catch {
            print(error)
        }
    }
}
