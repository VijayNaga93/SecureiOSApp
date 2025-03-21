//
//  ScreenRecordBlockView.swift
//  SecureApp
//
//  Created by Vijay N on 22/03/25.
//

import SwiftUI
import Combine

struct ScreenRecordBlockView: View {
    var screenRecordHandler = ScreenRecordBlockHandler()
    
    var body: some View {
        ZStack {
            // Main content
            VStack {
                Text("Sensitive Content")
                    .padding()
                    .background(screenRecordHandler.isScreenRecording ? Color.red : Color.clear)
            }
            
            // Overlay warning if screen recording is detected
            if screenRecordHandler.isScreenRecording {
                RecordingWarningOverlay()
            }
        }
        .onAppear(perform: screenRecordHandler.setupScreenRecordingObserver)
    }
    
}

#Preview {
    ScreenRecordBlockView()
}

class ScreenRecordBlockHandler: ObservableObject {
    
    @Published var isScreenRecording = false
    var cancellables = Set<AnyCancellable>()
    
    func setupScreenRecordingObserver() {
        // Initial check for screen recording
        isScreenRecording = UIScreen.main.isCaptured
        
        // Observe screen recording changes
        NotificationCenter.default.publisher(for: UIScreen.capturedDidChangeNotification)
            .receive(on: RunLoop.main)
            .sink { _ in
                self.isScreenRecording = UIScreen.main.isCaptured
            }
            .store(in: &cancellables)
    }
    
}

struct RecordingWarningOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 40))
                Text("Screen recording detected!")
                    .font(.title)
                    .foregroundColor(.white)
                Text("This app does not allow screen recording.")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
        .ignoresSafeArea()
    }
}
