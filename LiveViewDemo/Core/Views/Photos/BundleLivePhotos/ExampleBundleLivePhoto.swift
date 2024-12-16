//
//  ExampleBundleLivePhoto.swift
//  LiveViewDemo
//
//  Created by Apple on 15/12/2024.
//

import Foundation
import SwiftUI

struct ExampleBundleLivePhoto<VM: ExampleBundleLiveImageViewModelProtocol>: View {
    @StateObject var viewModel: VM = VM()
    @State var imageName: String = "live_photo_example"
    var body: some View {
        VStack(alignment: .center) {
            TextField("Enter file name", text: $imageName)
            Button("Generate") {
                viewModel.load(image: imageName)
            }
            if let livePhoto = viewModel.livePhoto {
                ZStack {
                    if livePhoto.progress < 100 {
                        CircularProgressView(conversion: $viewModel.livePhoto, message: "Converting")
                    } else if let content = livePhoto.content?.photo {
                        VStack {
                            LivePhotoContentView(photo: content)
                            Button {
                                viewModel.save()
                            } label: {
                                Text("Save")
                                    .font(.largeTitle.bold())
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal)
                            .frame(height: 40)
                            .background(.green)

                        }
                        
                    }
                }
                .padding()
            }
        }
    }
}
