import SwiftUI


enum UnitType: String, CaseIterable, Identifiable {
    case imperial = "Imperial"
    case metric = "Metric"

    var id: String { self.rawValue }
}

struct SetupView: View {
    let appVersion =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    let sensorVersion = "WICT901BLE"
    
    @EnvironmentObject var detector: TiltDetector
    @EnvironmentObject var settings: Settings

    var body: some View {
        NavigationView {
            VStack {
                Divider()
                Form {
                    Section(header: Text("Setup")) {
                        Picker("Label Orientation:", selection: $settings.selectedOrientation) {
                            ForEach(Orientation.allCases, id: \.self) { orientation in
                                Text(orientation.rawValue)
                                    .tag(orientation)
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
        detector.calibrate() // Call the calibration routing
        settings.rollOffset = -detector.roll
        settings.pitchOffset = -detector.pitch
    }
}


struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
