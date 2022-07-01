//
//  TiltDetector.swift
//  BubbleLevel (iOS)
//
//  Created by Matt Tooley on 5/10/22.
//
import Foundation

class TiltDetector: ObservableObject {
    //private var bleManager: BLEManagable = BLEManager()
    private var bleManager = BLEConnection()
    
    @Published var x = 0.0
    @Published var y = 0.0
    
    @Published var pitch: Double = 0
    @Published var roll: Double = 0
    @Published var zAcceleration = 0
    //Witmotion
    @Published var imuData: String?
    @Published var showAlert = false
    @Published var imuPitch: Double?
    @Published var imuRoll: Double?
    
    @Published var connected: Bool = false

    
    private var timer = Timer()
    private var updateInterval: TimeInterval
    
    init() {
        self.updateInterval = 0.01
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in self.updateTiltData()
            }
        bleManager.startCentralManager()
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
        
        // AdaFruit
        //if !dataString.isEmpty {
        //    //print("dataString: \(dataString)")
        //    let tiltarray = dataString.components(separatedBy: " ")
        //    let x = tiltarray[0]
        //    let y = tiltarray[1]
        //    roll = Double(x)!
        //    pitch = Double(y)!
        //}
        
        // WitMotion
        //print("dataString: \(dataString)")
        roll = bleManager.imuRoll ?? 0
        pitch = bleManager.imuPitch ?? 0

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
        connected = false

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
