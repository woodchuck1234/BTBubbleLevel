//
//  Arrow.swift
//  BTBubbleLevel
//
//  Created by Matt Tooley on 8/9/22.
//

import SwiftUI

struct Arrow: Shape {
    // 1.
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            // 2.
            path.addLines( [
                CGPoint(x: width * 0.4, y: height),
                CGPoint(x: width * 0.4, y: height * 0.4),
                CGPoint(x: width * 0.2, y: height * 0.4),
                CGPoint(x: width * 0.5, y: height * 0.1),
                CGPoint(x: width * 0.8, y: height * 0.4),
                CGPoint(x: width * 0.6, y: height * 0.4),
                CGPoint(x: width * 0.6, y: height)
                
            ])
            // 3.
            path.closeSubpath()
        }
    }
}
