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

    let task = URLSession.shared.downloadTask(with: url) { tempURL, _, error in
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

public enum Result<T> {
    case success(T)
    case failure(NSError)
}

class CacheManager {
    static let shared = CacheManager()

    private let fileManager = FileManager.default

    private lazy var mainDirectoryUrl: URL = {
        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()

    func getFileWith(stringUrl: String, completionHandler: @escaping (Result<URL>) -> Void) {
        let file = directoryFor(stringUrl: stringUrl)

        // return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path) else {
            completionHandler(Result.success(file))
            return
        }

        DispatchQueue.global().async {
            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                videoData.write(to: file, atomically: true)

                DispatchQueue.main.async {
                    completionHandler(Result.success(file))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(Result.failure(NSError(domain: "SomeErrorDomain", code: -2001)))
                }
            }
        }
    }

    private func directoryFor(stringUrl: String) -> URL {
        let fileURL = URL(string: stringUrl)!.lastPathComponent

        let file = mainDirectoryUrl.appendingPathComponent(fileURL)

        return file
    }
}
