//
//  DownloadImageOperation.swift
//  SomeApp
//
//  Created by Mykyta Vintonovych on 25.12.2020.
//

import Foundation

// MARK: - DownloadImageOperation

class DownloadImageOperation: AsyncOperation {
    
    // MARK: - Public properties
    
    var imageModel: ImageModel?
    
    // MARK: - Private properties
    
    private let imageUrl: URL
    private let fileService: FileServiceInput
    
    // MARK: - Init
    
    required init(imageUrl: URL, fileService: FileServiceInput) {
        self.imageUrl = imageUrl
        self.fileService = fileService
    }
    
    // MARK: - Override
    
    override func main() {
        
        let url = imageUrl
        let app = appId
        let imageName = url.lastPathComponent
        
        guard !fileService.fileExisted(fileName: imageName) else {
            
            if let localPath = fileService.directory(for: imageName) {
                appImageModel = ImageModel(imageName: imageName, localPath: localPath)
            }
            
            self.state = .finished
            
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [unowned self] data, response, error in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                self.state = .finished
                return
            }
            
            debugPrint("\nimage: \(imageName) was downloaded")
            
            guard let imageData = data else {
                debugPrint("Unable to get downloaded image data")
                self.state = .finished
                return
            }
            
            let fileService = FileService()
            
            fileService.save(data: imageData, name: imageName) { model in
                debugPrint("\nimage: \(imageName) was storred")
                self.imageModel = model
                self.state = .finished
            }
        }
        
        dataTask.resume()
    }
}
