//
//  MainVC.swift
//  pikachu 2
//
//  Created by Himanshu Joshi on 20/01/20.
//  Copyright © 2020 Himanshu Joshi. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    //Constants and Variables
    let label: UILabel = {
        let label = UILabel()
        label.text = "PIKACHU"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35.0)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .darkGray
        return label
    }()
    let cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "camera.png"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    let documentsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "health-report.png"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    func setupLabel() {
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40.0).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 50).isActive = true
    }
    func setupCameraButton() {
        self.view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.isUserInteractionEnabled = true
        cameraButton.layer.cornerRadius = 40
        cameraButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30.0).isActive = true
        cameraButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        cameraButton.addTarget(self, action: #selector(toMainVC), for: .allEvents)
    }
    
    @objc func toMainVC() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CameraVC") as? CameraVC
        self.present(nextViewController!, animated:true, completion:nil)
    }
    
    func setupDocumentsButton() {
        self.view.addSubview(documentsButton)
        documentsButton.translatesAutoresizingMaskIntoConstraints = false
        documentsButton.isUserInteractionEnabled = true
        documentsButton.layer.cornerRadius = 40
        documentsButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30.0).isActive = true
        documentsButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        documentsButton.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        documentsButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .lightGray
        setupLabel()
        setupCameraButton()
        setupDocumentsButton()

    }

}
