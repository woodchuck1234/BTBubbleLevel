//
//  Settings.swift
//  BTBubbleLevel
//
//  Created by Matthew Tooley on 6/29/23.
//

import Foundation

class Settings: ObservableObject {
    @Published var selectedOrientation: Orientation {
        didSet {
            UserDefaults.standard.set(selectedOrientation.rawValue, forKey: "selectedOrientation")
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
        let rawOrientation = UserDefaults.standard.string(forKey: "selectedOrientation") ?? Orientation.facingUp.rawValue
        self.selectedOrientation = Orientation(rawValue: rawOrientation) ?? .facingUp

        self.selectedUnit = UserDefaults.standard.string(forKey: "selectedUnit") ?? UnitType.imperial.rawValue
        self.rvLength = UserDefaults.standard.double(forKey: "rvLength")
        self.rvWidth = UserDefaults.standard.double(forKey: "rvWidth")
        self.rollOffset = UserDefaults.standard.double(forKey: "rollOffset")
        self.pitchOffset = UserDefaults.standard.double(forKey: "pitchOffset")
    }
}
