import SwiftUI
import RoomPlan

struct CaptureView: UIViewRepresentable {
    @Environment(RoomCaptureController.self) private var controller
    
    func makeUIView(context: Context) -> some UIView {
        controller.roomCaptureView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
struct ActivityView: UIViewControllerRepresentable {
  var items: [Any]
  var activities: [UIActivity]? = nil
  
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
      let controller = UIActivityViewController(activityItems: items, applicationActivities: activities)
      return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(RoomCaptureController.self) private var controller
    
    var body: some View {
        @Bindable var bindableController = controller
        
        NavigationStack {
            ZStack(alignment: .bottom) {
                if controller.roomCaptureView.isModelEnabled && controller.isScanning {
                    CaptureView()
                } else {
                    Text("room capture view is getting ready...")
                        .font(.title3).foregroundStyle(.tint)
                }
            }
            .navigationBarItems(leading: Button("취소") {
                controller.stopCaptureSession()
                print("tapped scanning cancel button")
            }, trailing: Button("내보내기") {
                controller.stopCaptureSession()
                controller.exportScanningResults()
                print("tapped export result button")
            }.sheet(isPresented: $bindableController.showShareSheet, content: {
                    if !controller.isScanning {
                        ActivityView(items: [controller.exportURL!]).onDisappear() {
                            presentationMode.wrappedValue.dismiss()
                            print("popover dismiss...")
                        }
                    }
                })
            )
            .navigationBarBackButtonHidden(true)
            
            if !controller.isScanning {
                Button(action: {
                    controller.startCaptureSession()
                    print("scanning action button")
                }, label: {
                    Text("스캔 시작하기")
                        .font(.title3)
                }).buttonStyle(.borderedProminent)
                    .opacity(controller.isScanning ? 0 : 1)
                    .padding()
            } else {
                Button(action: {
                    controller.stopCaptureSession()
                    print("scanning stop action button")
                }, label: {
                    Text("스캔 종료하기")
                        .font(.title3)
                }).buttonStyle(.borderedProminent)
                    .opacity(controller.isScanning ? 1 : 0)
                    .padding()
            }
        }
        
    }
}

#Preview {
    ContentView()
}
