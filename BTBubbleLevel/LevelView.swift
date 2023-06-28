/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct LevelView: View {
    @EnvironmentObject var tiltDetector : TiltDetector
    @EnvironmentObject var settings: Settings
    @ObservedObject var bleConnection = BLEConnection()

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    //Image("rvoutline").rotationEffect(.degrees((-90)))
                    //    .position(x: 185, y: 210)
                    //ArrowControllerView()
                    VStack (alignment: .center) {
                        BubbleLevel()
                        OrientationDataView()
                    }
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
            .padding()
            .alert(isPresented: $bleConnection.showAlert, content: {
                Alert(title: Text("Error"), message: Text("Connection Lost"))
            })
            .navigationBarTitle("Motorcoach Level Buddy",displayMode: .inline)
        }
        .environmentObject(Settings())
    }
}

struct LevelView_Previews: PreviewProvider {
    @StateObject static var tiltDetector = TiltDetector()
    @StateObject static var settings = Settings()
    
    static var previews: some View {
        LevelView()
            .environmentObject(tiltDetector)
            .environmentObject(settings)
    }
}
