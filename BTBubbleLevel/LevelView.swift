/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct LevelView: View {
    @EnvironmentObject var tiltDetector : TiltDetector

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Image("rvoutline").rotationEffect(.degrees((-90)))
                        .position(x: 185, y: 210)
                    VStack {
                        BubbleLevel().padding(.bottom, 80)
                        OrientationDataView()
                    }
                    BusView()
                }
                .navigationBarItems(trailing:
                    NavigationLink(destination:SetupView()) {
                    Image(systemName: "gear")
                })
                .onAppear {
                    tiltDetector.start()
                }
                .onDisappear {
                    tiltDetector.stop()
                }
            }
        }
    }
}

struct LevelView_Previews: PreviewProvider {
    @StateObject static var tiltDetector = TiltDetector()
    
    static var previews: some View {
        LevelView()
            .environmentObject(tiltDetector)
    }
}
                                         
