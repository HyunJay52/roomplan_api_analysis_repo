//import SwiftUI
//import RoomPlan
//
//struct CaptureView: UIViewRepresentable {
//    @Environment(RoomCaptureController.self) private var captureController
//    
//    func makeUIView(context: Context) -> some UIView {
//        captureController.roomCaptureView
//    }
//    
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        
//    }
//}
//
//struct ActivityView: UIViewControllerRepresentable {
//    var items: [Any]
//    var activities: [UIActivity]? = nil
//    
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> some UIViewController {
//        let controller = UIActivityViewController(activityItems: items, applicationActivities: activities)
//        
//        return controller
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ActivityView>) {
//        //
//    }
//}
//
//struct ScanningView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @Environment(RoomCaptureController.self) private var roomCaptureController
//
//    var body: some View {
//        @Bindable var bindableController = roomCaptureController
//        
//        VStack(alignment: .leading) {
//            Text("Hello, World!")
//            Text("Roomplan Test app")
//        }
//        
//        ZStack(alignment: .bottom) {
//            CaptureView()
//                .navigationBarBackButtonHidden(true)
//                .navigationBarItems(leading: Button("Cancel") {
//                    roomCaptureController.stopSession()
//                    presentationMode.wrappedValue.dismiss()
//                    print("cancel click to stop session...")
//                })
//                .navigationBarItems(trailing: Button("Done"){
//                    roomCaptureController.stopSession()
//                    roomCaptureController.showExportButton  = true
//                    print("Done click to stop session...")
//                }).opacity(roomCaptureController.showExportButton ? 0 : 1).onAppear() {
//                    roomCaptureController.showExportButton = false
//                    roomCaptureController.startSession()
//                }
//            Button(action: {
//                roomCaptureController.exportResults()
//            }, label: {
//                Text("Export Scanning Result").font(.title2)
//            }).buttonStyle(.borderedProminent)
//                .cornerRadius(40)
//                .opacity(roomCaptureController.showExportButton ? 1 : 0)
//                .padding()
////                .sheet(isPresented: $bindableController.showExportButton, content: {
////                    ActivityView(items: [roomCaptureController.exportButton]).onDisappear() {
////                        presentationMode.wrappedValue.dismiss()
////                    })
////                })
//        }
//    }
//}
//
//#Preview {
//    ScanningView()
//}
