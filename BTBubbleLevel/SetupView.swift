import SwiftUI

enum Orientation: String, CaseIterable, Identifiable {
    case facingUp = "Facing Up"
    case facingDown = "Facing Down"
    case facingLeft = "Facing Left"
    case facingRight = "Facing Right"
    case facingRear = "Facing Rear"

    var id: String { self.rawValue }
}

enum UnitType: String, CaseIterable, Identifiable {
    case imperial = "Imperial"
    case metric = "Metric"

    var id: String { self.rawValue }
}

class Settings: ObservableObject {
    @Published var selectedOrientation: String {
        didSet {
            UserDefaults.standard.set(selectedOrientation, forKey: "selectedOrientation")
        }
    }
    @Published var selectedUnit: String {
        didSet {
            UserDefaults.standard.set(selectedUnit, forKey: "selectedUnit")
        }
    }
    @Published var rvLength: Double {
        didSet {
            UserDefaults.standard.set(rvLength, forKey: "rvLength")
        }
    }
    @Published var rvWidth: Double {
        didSet {
            UserDefaults.standard.set(rvWidth, forKey: "rvWidth")
        }
    }
    @Published var rollOffset: Double {
        didSet {
            UserDefaults.standard.set(rollOffset, forKey: "rollOffset")
        }
    }
    @Published var pitchOffset: Double {
        didSet {
            UserDefaults.standard.set(pitchOffset, forKey: "pitchOffset")
        }
    }

    init() {
        self.selectedOrientation = UserDefaults.standard.string(forKey: "selectedOrientation") ?? Orientation.facingUp.rawValue
        self.selectedUnit = UserDefaults.standard.string(forKey: "selectedUnit") ?? UnitType.imperial.rawValue
        self.rvLength = UserDefaults.standard.double(forKey: "rvLength")
        self.rvWidth = UserDefaults.standard.double(forKey: "rvWidth")
        self.rollOffset = UserDefaults.standard.double(forKey: "rollOffset")
        self.pitchOffset = UserDefaults.standard.double(forKey: "pitchOffset")
    }
}

struct SetupView: View {
    let appVersion =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    let sensorVersion = "WICT901BLE"
    
    @EnvironmentObject var detector: TiltDetector
    @ObservedObject var settings = Settings()

    var body: some View {
        NavigationView {
            VStack {
                Divider()
                Form {
                    Section(header: Text("Setup")) {
                        Picker("Label Orientation:", selection: $settings.selectedOrientation) {
                            ForEach(Orientation.allCases) { orientation in
                                Text(orientation.rawValue)
                                    .tag(orientation.rawValue)
                            }
                        }
                        Picker("Units:", selection: $settings.selectedUnit) {
                            ForEach(UnitType.allCases) { unit in
                                Text(unit.rawValue)
                                    .tag(unit.rawValue)
                            }
                        }
                    }
                    Section (header: Text("Calibrate Level")) {
                        Button(action: {
                            // Perform zero level action
                            zeroLevelAction()
                        }) {
                            Text("Zero Level")
                                .frame(alignment: .center)
                        }
                    }
                    Section(header: Text("Dimensions")) {
                        Stepper(value: $settings.rvLength, in: 1...50, step: 1) {
                            Text("RV Length: \(Int(settings.rvLength)) ft")
                        }
                        .padding(.leading, 20)
                        
                        Stepper(value: $settings.rvWidth, in: 1...15, step: 1) {
                            Text("RV Width: \(Int(settings.rvWidth)) ft")
                        }
                        .padding(.leading, 20)
                    }
                    Section(header: Text("About")) {
                        Text("Version: \(appVersion)")
                            .font(.subheadline)
                        Text("Sensor: \(sensorVersion)")
                            .font(.subheadline)
                        Text("Motorcoach Level Buddy by rIvOT")
                            .font(.subheadline)
                        Text("Got Toad?")
                            .font(.subheadline)
        
                    }
                }
            }
            .navigationBarTitle("Setup", displayMode: .inline) // Set the display mode to inline
            .padding(.top, 1) // Adjust the top padding to move the content up

        }
    }
    
    private func zeroLevelAction() {
        // This method will be called when the "Zero Level" button is pressed
        // Read sensor roll and pitch values and save them to UserDefaults
        settings.rollOffset = -detector.roll
        settings.pitchOffset = -detector.pitch
    }
}


struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
