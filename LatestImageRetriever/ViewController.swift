//
//  ViewController.swift
//  LatestImageRetriever
//
//  Created by Keegan Rush on 30.06.2017.
//  Copyright © 2017 TheCodedSelf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func showLatestImage(_ sender: Any) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        guard let url = URL(string: "http://localhost:8090/latestImage") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Something went wrong: \(error)")
            }
            
            if let imageData = data {
                // The UI should be updated from the main thread
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                }
            }
        }.resume()
    }
    
    @IBAction func pickImage(_ sender: Any) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    func submit(image: UIImage) {

        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        guard let url = URL(string: "http://localhost:8090/image") else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = UIImageJPEGRepresentation(image, 0)
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Something went wrong: \(error)")
            }
            
            if let response = response {
                print("Response: \(response)")
            }
        }.resume()
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [String: Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            submit(image: image)
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            submit(image: image)
        }
        
        picker.dismiss(animated: true)
    }
}
