//
//  ScreenShotBlockView.swift
//  SecureApp
//
//  Created by Vijay N on 19/03/25.
//

import SwiftUI

struct ScreenShotBlockView: View {
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                Text("Prevent screenshot")
                
                    .padding()
                Image(systemName: "photo.artframe")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width / 3, height: geometry.size.height / 3, alignment: .center)
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .foregroundStyle(.orange)
        }
        .padding()
        
        .preventScreenshot()
    }
    
}

#Preview {
    ScreenShotBlockView()
}


/*
 Note trigger screenshot using this like realtime device screenshot:
 
 Go to Simulator > Device > Trigger Screenshot
 */

public struct ScreenshotPreventView<Content: View>: UIViewRepresentable {
    
    let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public func makeUIView(context: Context) -> UIView {
        
        let secureTextField = UITextField()
        secureTextField.isSecureTextEntry = true
        secureTextField.isUserInteractionEnabled = false
        
        guard let secureView = secureTextField.layer.sublayers?.first?.delegate as? UIView else {
            return UIView()
        }
        
        secureView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        let hController = UIHostingController(rootView: content())
        hController.view.backgroundColor = .clear
        hController.view.translatesAutoresizingMaskIntoConstraints = false
        
        secureView.addSubview(hController.view)
        NSLayoutConstraint.activate([
            hController.view.topAnchor.constraint(equalTo: secureView.topAnchor),
            hController.view.bottomAnchor.constraint(equalTo: secureView.bottomAnchor),
            hController.view.leadingAnchor.constraint(equalTo: secureView.leadingAnchor),
            hController.view.trailingAnchor.constraint(equalTo: secureView.trailingAnchor)
        ])
        
        return secureView
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) { }
}

extension View {
    
    @ViewBuilder func preventScreenshot(_ shouldPrevent: Bool = true) -> some View {
        if shouldPrevent {
            ScreenshotPreventView { self }
        } else {
            self
        }
    }
}





