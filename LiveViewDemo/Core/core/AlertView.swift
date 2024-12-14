//
//  AlertView.swift
//  LiveViewDemo
//
//  Created by Apple on 15/12/2024.
//

import Foundation
import SwiftUI

public struct TextualDesign {
    public let color: Color
    public let font: Font
    public init(color: Color, font: Font) {
        self.color = color
        self.font = font
    }
}
public struct ButtonDesign {
    public let background: Color
    public let color: Color
    public let font: Font
    public init(background: Color, color: Color, font: Font) {
        self.background = background
        self.color = color
        self.font = font
    }
}

public struct AlertContent: Identifiable {
    public var id: String { title + subtitle }
    public let title: String
    public let subtitle: String
    public let image: String?
    public init(title: String, subtitle: String, image: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
}

public struct AlertDesign {
    public let title: TextualDesign
    public let subtitle: TextualDesign
    public let cross: ButtonDesign
    public let ok: ButtonDesign
    
    static public var error: AlertDesign {
        AlertDesign(
            title: TextualDesign(
                color: .red,
                font: .largeTitle.bold()
            ),
            subtitle: TextualDesign(
                color: .red,
                font: .title
            ),
            cross: ButtonDesign(
                background: .red.opacity(0.25),
                color: .red,
                font: .body
            ),
            ok: ButtonDesign(
                background: .red.opacity(0.25),
                color: .red,
                font: .largeTitle.bold()
            )
        )
    }
}

public struct AlertView: View {
    // MARK: - Properties
    var alert: AlertContent
    @Binding var isPresented: Bool
    let design: AlertDesign
    @State var scale: CGFloat = 0
    @Environment(\.dismiss) var dismiss
    public init(alert: AlertContent, isPresented: Binding<Bool>, design: AlertDesign = .error) {
        self.alert = alert
        _isPresented = isPresented
        self.design = design
    }
    // MARK: - Body
    public var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(design.cross.color)
                            .font(design.cross.font)
                            .padding(8)
                            .background(design.cross.background)
                            .clipShape(Circle())
                    }
                }
                if let imageName = alert.image {
                    ZStack(alignment: .topTrailing) {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .clipped()
                    }
                }

                Text(alert.title)
                    .font(design.title.font)
                    .foregroundStyle(design.title.color)
                    .multilineTextAlignment(.center)

                Text(alert.subtitle)
                    .font(design.subtitle.font)
                    .foregroundStyle(design.subtitle.color)
                    .multilineTextAlignment(.center)
                    

                Button(action: {
                    dismiss()
                }) {
                    Text("OK")
                        .font(design.ok.font)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(design.ok.background)
                        .foregroundColor(design.ok.color)
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 8)
            .frame(maxWidth: 300)
            .scaleEffect(CGSize(width: scale, height: scale), anchor: .center)
            .onAppear() {
                let animation = Animation.bouncy(duration: 0.3, extraBounce: 0.3)
                withAnimation(animation) {
                    self.scale = 1.0
                }
            }
        }
    }
}
// MARK: - Preview
struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(
            alert: AlertContent(
                title: "Example",
                subtitle: "laksdhla dha sdhjkas dkjahs dajkhdk ajk djh ajksdj ajk sdh"
            ),
            isPresented: .constant(true)
        )
    }
}
