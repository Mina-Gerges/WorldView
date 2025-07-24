//
//  CachedAsyncImage.swift
//  WorldView
//
//  Created by Mina Gerges on 25/07/2025.
//

import SwiftUI

struct CachedAsyncImage: View {
    @StateObject private var loader = ImageLoader()
    let url: URL?
    let placeholder: () -> AnyView
    let image: (Image) -> AnyView

    init(
        url: URL?,
        @ViewBuilder placeholder: @escaping () -> AnyView,
        @ViewBuilder image: @escaping (Image) -> AnyView
    ) {
        self.url = url
        self.placeholder = placeholder
        self.image = image
    }

    var body: some View {
        content
            .onAppear {
                loader.load(from: url)
            }
            .onDisappear {
                loader.cancel()
            }
    }

    private var content: some View {
        Group {
            if let uiImage = loader.image {
                image(Image(uiImage: uiImage))
            } else {
                placeholder()
            }
        }
    }
}
