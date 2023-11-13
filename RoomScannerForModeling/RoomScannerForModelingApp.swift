import SwiftUI

@main
struct RoomScannerForModelingApp: App {
    static let controller = RoomCaptureController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(RoomScannerForModelingApp.controller)
        }
    }
}
