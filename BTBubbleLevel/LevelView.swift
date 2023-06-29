import SwiftUI

struct LevelView: View {
    @EnvironmentObject var tiltDetector: TiltDetector
    @ObservedObject var settings: Settings
    @ObservedObject var bleConnection = BLEConnection()

    init(settings: Settings) {
        self.settings = settings
    }

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    VStack(alignment: .center) {
                        BubbleLevel()
                        OrientationDataView()
                    }
                }
                .navigationBarItems(trailing:
                    NavigationLink(destination: SetupView().environmentObject(settings)) {
                        Image(systemName: "gear")
                    }
                )
                .onAppear {
                    tiltDetector.start()
                }
                .onDisappear {
                    tiltDetector.stop()
                }
            }
            .padding()
            .alert(isPresented: $bleConnection.showAlert) {
                Alert(title: Text("Error"), message: Text("Connection Lost"))
            }
            .navigationBarTitle("Motorcoach Level Buddy", displayMode: .inline)
        }
        .environmentObject(tiltDetector)
        .environmentObject(settings)
    }
}

struct LevelView_Previews: PreviewProvider {
    @StateObject static var tiltDetector = TiltDetector(settings: settings)
    @StateObject static var settings = Settings()

    static var previews: some View {
        LevelView(settings: settings)
            .environmentObject(tiltDetector)
            .environmentObject(settings)
    }
}
