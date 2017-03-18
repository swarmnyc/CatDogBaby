//
//  CameraViewController.swift
//  CatDogBaby
//
//  Created by William Robinson on 3/18/17.
//  Copyright © 2017 William Robinson. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyCam
import AVFoundation

class CameraViewController: SwiftyCamViewController {
	
	// Views
	lazy var captureButton: CaptureButton = {
		let button: CaptureButton = CaptureButton()
		button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
		self.view.addSubview(button)
		return button
	}()
	lazy var backgroundBlurView: UIVisualEffectView = {
		let blurView: UIVisualEffectView = UIVisualEffectView()
		blurView.isHidden = true
		self.view.addSubview(blurView)
		return blurView
	}()
	lazy var capturedPhotoImageView: UIImageView = {
		let imageView: UIImageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 8
		imageView.clipsToBounds = true
		imageView.alpha = 0
		imageView.isHidden = true
		self.view.addSubview(imageView)
		return imageView
	}()
	lazy var closeButton: CloseButton = {
		let button: CloseButton = CloseButton()
		button.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
		button.alpha = 0
		button.isHidden = true
		self.view.addSubview(button)
		return button
	}()
	lazy var animalButton: UIButton = {
		let button: UIButton = UIButton()
		button.imageView!.contentMode = .scaleAspectFill
		button.layer.cornerRadius = 80
		button.clipsToBounds = true
		button.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
		button.alpha = 0
		button.isHidden = true
		self.view.addSubview(button)
		return button
	}()
	
	// Animals
	lazy var animals: [Animal] = [
		Animal(image: #imageLiteral(resourceName: "TubeCat"), utterance: AVSpeechUtterance(string: "This animal is a cat.")),
		Animal(image: #imageLiteral(resourceName: "HappyDog"), utterance: AVSpeechUtterance(string: "This animal is a dog.")),
		Animal(image: #imageLiteral(resourceName: "ConfusedBaby"), utterance: AVSpeechUtterance(string: "This animal is a baby."))
	]
	
	// Speech
	lazy var speechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
	
	// Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		cameraDelegate = self
		updateViewConstraints()
	}
	
	// Layout
	override func updateViewConstraints() {
		captureButton.snp.remakeConstraints {
			$0.bottom.equalToSuperview().offset(-30)
			$0.centerX.equalToSuperview()
			$0.width.height.equalTo(100)
		}
		backgroundBlurView.snp.remakeConstraints {
			$0.edges.equalToSuperview()
		}
		capturedPhotoImageView.snp.remakeConstraints {
			$0.center.equalToSuperview()
			$0.width.height.equalToSuperview().dividedBy(1.3)
		}
		closeButton.snp.remakeConstraints {
			$0.top.left.equalTo(capturedPhotoImageView)
			$0.width.equalTo(60)
			$0.height.equalTo(70)
		}
		animalButton.snp.remakeConstraints {
			$0.center.equalToSuperview()
			$0.width.height.equalTo(160)
		}
		super.updateViewConstraints()
	}
	
	// Actions
	func capturePhoto() {
		takePhoto()
	}
	func closePopup() {
		
		// Stop synthesizer if speaking
		self.speechSynthesizer.stopSpeaking(at: .immediate)
		
		// Hide popup
		UIView.animate(
			withDuration: 0.2,
			delay: 0,
			options: .curveEaseInOut,
			animations: {
				self.backgroundBlurView.effect = nil
				self.capturedPhotoImageView.alpha = 0
				self.closeButton.alpha = 0
				self.animalButton.alpha = 0
		}) { _ in
			self.backgroundBlurView.isHidden = true
			self.capturedPhotoImageView.isHidden = true
			self.closeButton.isHidden = true
			self.animalButton.isHidden = true
			self.capturedPhotoImageView.image = nil
		}
	}
}

// Capture delegate
extension CameraViewController: SwiftyCamViewControllerDelegate {
	func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
		
		// Set images
		capturedPhotoImageView.image = photo
		let animal = animals[Int(arc4random_uniform(UInt32(animals.count)))]
		self.animalButton.setImage(animal.image, for: .normal)
		
		// Prepare to show views
		backgroundBlurView.isHidden = false
		capturedPhotoImageView.isHidden = false
		closeButton.isHidden = false
		animalButton.isHidden = false
		
		// Show popup
		UIView.animate(
			withDuration: 0.2,
			delay: 0,
			options: .curveEaseInOut,
			animations: {
				self.backgroundBlurView.effect = UIBlurEffect(style: .dark)
				self.capturedPhotoImageView.alpha = 1
				self.closeButton.alpha = 1
		})
		UIView.animate(
			withDuration: 0.2,
			delay: 0.3,
			options: .curveEaseInOut,
			animations: {
				self.animalButton.alpha = 1
		}) { _ in
			self.speechSynthesizer.speak(animal.utterance)
		}
	}
}
