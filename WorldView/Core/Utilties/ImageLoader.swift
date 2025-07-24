//
//  ImageLoader.swift
//  WorldView
//
//  Created by Mina Gerges on 25/07/2025.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private static let cache = NSCache<NSURL, UIImage>()
    
    private var cancellable: AnyCancellable?
    
    func load(from url: URL?) {
        guard let url else { return }
        
        if let cachedImage = ImageLoader.cache.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { image in
                if let image {
                    ImageLoader.cache.setObject(image, forKey: url as NSURL)
                }
            })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    func cancel() {
        cancellable?.cancel()
    }
}
