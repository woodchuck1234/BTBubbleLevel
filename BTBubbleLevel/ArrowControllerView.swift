//
//  ArrowControllerView.swift
//  BTBubbleLevel
//
//  Created by Matt Tooley on 8/9/22.
//

import SwiftUI

struct ArrowControllerView: View {
    var body: some View {
        
        ZStack {
            Circle()
                .foregroundColor(Color.orange.opacity(0.25))
                .frame(width: 200, height: 200, alignment: .center)
            VStack(alignment: .center) {
                Arrow()
                    .frame(width: 100, height: 40, alignment: .center)
                Arrow()
                    .rotation(Angle(degrees: 180))
                    .frame(width: 100, height: 40)
                HStack() {
                    VStack() {
                        Arrow()
                            .frame(width: 100, height: 40, alignment: .center)

                        Arrow()
                            .rotation(Angle(degrees: 180))
                            .frame(width: 100, height: 40)

                    }
                    Spacer()
                        .frame(minWidth: 100, idealWidth: 150, maxWidth: 300, minHeight: 100, idealHeight: 300, maxHeight: 400, alignment: .center)
                    VStack {
                        Arrow()
                            .frame(width: 100, height: 40, alignment: .center)

                        Arrow()
                            .rotation(Angle(degrees: 180))
                            .frame(width: 100, height: 40)

                    }
                }
                Arrow()
                    .frame(width: 100, height: 40, alignment: .center)
                Arrow()
                    .rotation(Angle(degrees: 180))

                    .frame(width: 100, height: 40)

            }
        }
    }
}

struct ArrowControllerView_Previews: PreviewProvider {
    static var previews: some View {
        ArrowControllerView()
    }
}
