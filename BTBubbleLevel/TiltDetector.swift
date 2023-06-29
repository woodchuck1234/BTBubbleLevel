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
    private var settings:Settings
    
    @Published var x = 0.0
    @Published var y = 0.0
    
    @Published var pitch: Double = 0
    @Published var roll: Double = 0
    @Published var yaw: Double = 0
    @Published var zAcceleration = 0
    @Published var currentOrientation: Orientation = .facingUp
    //Witmotion
    @Published var imuData: String?
    @Published var showAlert = false
    @Published var imuPitch: Double?
    @Published var imuRoll: Double?
    @Published var battery: Int?
    @Published var temperature: Double?
    
    @Published var connected: Bool = false

    
    private var timer = Timer()
    private var updateInterval: TimeInterval
    
    init(settings:Settings) {
        self.updateInterval = 1.0
        self.settings = settings
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
        
        switch settings.selectedOrientation {
        case .facingUp:
            roll = bleManager.imuRoll ?? 0
            pitch = bleManager.imuPitch ?? 0
            yaw = bleManager.imuYaw ?? 0
            break
        case .facingDown:
            // Handle facingDown case
            roll = (bleManager.imuRoll ?? 0)
            pitch = bleManager.imuPitch ?? 0
            yaw = bleManager.imuYaw ?? 0
            break
        case .facingLeft:
            // Handle facingLeft case
            roll = (bleManager.imuRoll ?? 0)
            pitch = bleManager.imuPitch ?? 0
            yaw = bleManager.imuYaw ?? 0
            break
        case .facingRight:
            // Handle facingRight case
            roll = (bleManager.imuRoll ?? 0)
            pitch = bleManager.imuPitch ?? 0
            yaw = bleManager.imuYaw ?? 0
            break
        case .facingRear:
            // Handle facingRear case
            roll = bleManager.imuRoll ?? 0
            pitch = (bleManager.imuPitch ?? 0)
            yaw = bleManager.imuYaw ?? 0
            break
        default:
            break
        }
        

        battery = bleManager.battery ?? 100
        temperature = bleManager.sensorTemp ?? 70.0

    }
    
    func stop() {
        timer.invalidate()
    }
    
    func calibrate() {
        bleManager.calibrate()
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
