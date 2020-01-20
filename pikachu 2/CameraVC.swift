//
//  ViewController.swift
//  pikachu 2
//
//  Created by Himanshu Joshi on 19/01/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit
import VisionKit
import Vision

class CameraVC: UIViewController {
    
    //Private Variables
    private var requests = [VNRequest]()
    private let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    private var resultingText = ""
    
    //Variables and Constants
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .lightGray
        textView.font = UIFont(name: "HelveticaNeue", size: 15.0)
        textView.textColor = .black
        textView.text = "Press the camera button to recognize text in any image.. "
        textView.textAlignment = .center
        return textView
    }()
    let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "camera.png"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .black
        return activityIndicator
    }()
    
    func setupTextView() {
        self.view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = true
        textView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15.0).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15.0).isActive = true
        textView.heightAnchor.constraint(equalToConstant: self.view.bounds.height - 100).isActive = true
    }
    func setupButton() {
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 40
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10.0).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        button.addTarget(self, action: #selector(buttonTapped), for: .allEvents)
    }
    func setupActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .darkGray
        setupTextView()
        setupButton()
        setupVision()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    private func setupVision() {
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("The observations are of an unexpected type.")
                return
            }
            let maximumCandidates = 1
            for observation in observations {
                guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                self.resultingText += candidate.string + "\n"
            }
        }
        textRecognitionRequest.recognitionLevel = .accurate
        self.requests = [textRecognitionRequest]
    }

    @objc func buttonTapped() {
        
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
        
    }
    
    //Hide Keyboard Function
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(disissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func disissKeyboard() {
        view.endEditing(true)
    }
        
}

extension CameraVC: VNDocumentCameraViewControllerDelegate {
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        textView.text = ""
        controller.dismiss(animated: true, completion: nil)
        setupActivityIndicator()
        activityIndicator.isHidden = false
        textRecognitionWorkQueue.async {
            self.resultingText = ""
            for pageIndex in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                if let cgImage = image.cgImage {
                    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                    do {
                        try requestHandler.perform(self.requests)
                    } catch {
                        print(error)
                    }
                }
                self.resultingText += "\n\n"
            }
            DispatchQueue.main.async(execute: {
                self.textView.text = self.resultingText
                self.activityIndicator.isHidden = true
            })
        }
    }
    
}
