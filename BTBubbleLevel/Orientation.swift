//
//  Orientation.swift
//  BTBubbleLevel
//
//  Created by Matthew Tooley on 6/29/23.
//

import Foundation

enum Orientation: String, CaseIterable, Identifiable {
    case facingUp = "Facing Up"
    case facingDown = "Facing Down"
    case facingLeft = "Facing Left"
    case facingRight = "Facing Right"
    case facingRear = "Facing Rear"

    var id: String { self.rawValue }
}
