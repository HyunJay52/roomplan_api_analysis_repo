import SwiftUI
import RoomPlan
import Observation

struct RefinedCapturedRoom : Codable, Sendable  {
    var walls: [CapturedRoom.Surface]
    var floors: [CapturedRoom.Surface]
    var windows: [CapturedRoom.Surface]
    var doors: [CapturedRoom.Surface]
}
extension CapturedRoom {
    var refinedCapturedRoom : RefinedCapturedRoom {
        let refinedWalls = walls
        let refinedFloors = floors
        let refinedWindows = windows
        let refinedDoors = doors
        
        return RefinedCapturedRoom(walls: refinedWalls, floors: refinedFloors, windows: refinedWindows, doors: refinedDoors)
    }
}

@Observable
class RoomCaptureController : RoomCaptureViewDelegate, RoomCaptureSessionDelegate {
    func encode(with coder: NSCoder) {
        fatalError("not needed...")
    }
    required init?(coder: NSCoder) {
        fatalError("not needed...")
    }
    
    var isScanning: Bool = false
    
    // Roomplan : Data API
    var roomCaptureView: RoomCaptureView
    var captureSessionConfig: RoomCaptureSession.Configuration
    
    // usdz file, json file
    var showShareSheet = false
    var exportURL: URL?
    var finalResults: CapturedRoom?
//    var finalResults: RefinedCapturedRoom?
    
    init() {
        roomCaptureView = RoomCaptureView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        captureSessionConfig = RoomCaptureSession.Configuration()
        roomCaptureView.captureSession.delegate = self
        roomCaptureView.delegate = self
        
        print("roomCaptureView -> \(roomCaptureView.isModelEnabled)")
    }

    func startCaptureSession() {
        isScanning = true
        roomCaptureView.captureSession.run(configuration: captureSessionConfig)
    }
    
    func stopCaptureSession() {
        isScanning = false
        roomCaptureView.captureSession.stop()
    }
    
    func doneScanning(_ sender: UIBarButtonItem) {
        if isScanning { stopCaptureSession() } else { cancelScanning(sender) }
    }
    
    func cancelScanning(_ sender: UIBarButtonItem) {
        stopCaptureSession()
    }

    /// post process and show the final results
    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
        return true
    }
    /// access the final post-processed results
    func captureView(didPresent processedResult: CapturedRoom, error: (Error)?) {
        let refinedProcessedResult = RefinedCapturedRoom(walls: processedResult.walls, floors: processedResult.floors, windows: processedResult.windows, doors: processedResult.doors)
        print("processedResult >>>>>>>> \n \(processedResult) \n >>>>>>>>>>>>>>>>")
//        finalResults = refinedProcessedResult
//        processedResult.Object.Category.allCases
        
        finalResults = processedResult
    }
    
    func exportScanningResults() {
        let destinationFolderURL = FileManager.default.temporaryDirectory.appending(path: "Export")
        let destinationURL = destinationFolderURL.appending(path: "Room.usdz")
        let capturedRoomURL = destinationFolderURL.appending(path: "Room.json")
        
        print("destinationFolderURL : \(destinationFolderURL)")
        print("destinationURL : \(destinationURL)")
        print("captureRoomURL : \(capturedRoomURL)")
        
        do {
            print("??? is final result is empty ... \(finalResults.debugDescription)")
            
            if finalResults == nil {
                print("final result is empty ... \(finalResults.debugDescription)")
                return
            }
            
            try FileManager.default.createDirectory(at: destinationFolderURL, withIntermediateDirectories: true)
            
            let jsonData = try JSONEncoder().encode(finalResults)
            try jsonData.write(to: capturedRoomURL)
            try finalResults?.export(to: destinationURL, exportOptions: CapturedRoom.USDExportOptions.parametric)
            
            exportURL = destinationFolderURL
            showShareSheet = true
        } catch {
            print("Export Error ---> \(error)")
        }
    }
}
