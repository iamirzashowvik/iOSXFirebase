//
//  CacheService.swift
//  SwiftUI_Firebase
//
//  Created by Mirza Showvik on 29/11/23.
//




import Foundation

func downloadAndCacheVideo(from url: URL, completion: @escaping (URL?) -> Void) {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let destinationURL = documentsURL.appendingPathComponent("cachedVideo.mp4")

    let task = URLSession.shared.downloadTask(with: url) { (tempURL, response, error) in
        guard let tempURL = tempURL, error == nil else {
            print("Error downloading video: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }
        do {
            try FileManager.default.moveItem(at: tempURL, to: destinationURL)
            completion(destinationURL)
        } catch {
            print("Error moving video to destination: \(error.localizedDescription)")
            completion(nil)
        }
    }
    task.resume()
}
