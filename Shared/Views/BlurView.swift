//
//  BlurView.swift
//  DesignCodeTutorial
//
//  Created by Travis Gerrard on 8/13/20.
//

import SwiftUI


struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIView
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = .clear

        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct BlurViewTwo: View {
    @Environment(\.colorScheme) var scheme

    var active: Bool
    var onTap: () -> ()

    var body: some View {
        if active {
            VisualEffectView(uiVisualEffect: UIBlurEffect(style: scheme == .dark ? .dark : .light))
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: self.onTap)
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    var uiVisualEffect: UIVisualEffect?
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = uiVisualEffect
    }
}
