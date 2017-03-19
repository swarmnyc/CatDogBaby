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

/// Defines the possible states during animal identification process
protocol AnimalIdentificationProtocol {
	var isIdentifying: Bool { get }
}

/// Main application view controller
class CameraViewController: SwiftyCamViewController, AnimalIdentificationProtocol {
	
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
	lazy var popupView: UIView = {
		let view: UIView = UIView()
		view.layer.cornerRadius = 8
		view.clipsToBounds = true
		view.backgroundColor = StyleKit.transparentWhite
		view.alpha = 0
		view.isHidden = true
		self.view.addSubview(view)
		return view
	}()
	lazy var capturedPhotoImageView: UIImageView = {
		let imageView: UIImageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		self.popupView.addSubview(imageView)
		return imageView
	}()
	lazy var closeButton: CloseButton = {
		let button: CloseButton = CloseButton(self)
		button.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
		self.popupView.addSubview(button)
		return button
	}()
	lazy var idLabel: UILabel = {
		let label: UILabel = UILabel()
		label.text = "Identifying..."
		label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
		label.textColor = UIColor.white.withAlphaComponent(0.6)
		self.popupView.addSubview(label)
		return label
	}()
	lazy var animalButton: UIButton = {
		let button: UIButton = UIButton()
		button.imageView!.contentMode = .scaleAspectFill
		button.imageView!.layer.cornerRadius = 25
		button.imageView!.clipsToBounds = true
		button.layer.shadowRadius = 10
		button.layer.shadowOffset = CGSize.zero
		button.layer.shadowOpacity = 0.2
		button.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
		self.popupView.addSubview(button)
		return button
	}()
	lazy var loadingView: UIActivityIndicatorView = {
		let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
		self.popupView.addSubview(indicatorView)
		return indicatorView
	}()
	
	// Data
	lazy var dataManager: DataManager = DataManager()
	
	// Animals
	lazy var cat: Animal = {
		return Animal(image: #imageLiteral(resourceName: "TubeCat"),
		              utterance: AVSpeechUtterance(string: "This animal is a cat."),
		              description: "Cat")
	}()
	lazy var dog: Animal = {
		return Animal(image: #imageLiteral(resourceName: "HappyDog"),
		              utterance: AVSpeechUtterance(string: "This animal is a dog."),
		              description: "Dog")
	}()
	lazy var baby: Animal = {
		return Animal(
			image: #imageLiteral(resourceName: "ConfusedBaby"),
			utterance: AVSpeechUtterance(string: "This animal is probably some kind of baby."),
			description: "Baby")
	}()
	lazy var biggestBaby: Animal = {
		return Animal(
			image: #imageLiteral(resourceName: "ConfusedBaby"),
			utterance: AVSpeechUtterance(string: "This animal is probably the biggest kind of baby."),
			description: "Big Baby")
	}()
	
	// Speech
	lazy var speechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
	
	// Status
	var isIdentifying: Bool = true {
		didSet {
			closeButton.setNeedsDisplay()
		}
	}
	
	// Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		cameraDelegate = self
		updateViewConstraints()
	}
	
	// Layout
	override func updateViewConstraints() {
		captureButton.snp.remakeConstraints {
			$0.bottom.equalToSuperview().inset(30)
			$0.centerX.equalToSuperview()
			$0.width.height.equalTo(100)
		}
		backgroundBlurView.snp.remakeConstraints {
			$0.edges.equalToSuperview()
		}
		popupView.snp.remakeConstraints {
			$0.center.equalToSuperview()
			$0.width.height.equalToSuperview().dividedBy(1.2)
		}
		capturedPhotoImageView.snp.remakeConstraints {
			$0.bottom.centerX.width.equalToSuperview()
			$0.height.equalToSuperview().offset(-90)
		}
		closeButton.snp.remakeConstraints {
			$0.top.left.equalToSuperview()
			$0.width.equalTo(70)
			$0.height.equalTo(90)
		}
		idLabel.snp.remakeConstraints {
			$0.top.centerX.equalToSuperview()
			$0.height.equalTo(90)
		}
		animalButton.snp.remakeConstraints {
			$0.top.right.equalToSuperview().inset(20)
			$0.width.height.equalTo(50)
		}
		loadingView.snp.remakeConstraints {
			$0.center.equalTo(animalButton)
		}
		super.updateViewConstraints()
	}
	
	// Actions
	func capturePhoto() {
		isIdentifying = true
		captureButton.isUserInteractionEnabled = false
		takePhoto()
	}
	func closePopup() {
		// Stop synthesizer if speaking
		self.speechSynthesizer.stopSpeaking(at: .immediate)
		self.dataManager.didTimeout = true
		self.dataManager.timer?.invalidate()
		// Hide popup
		self.view.layoutIfNeeded()
		UIView.animate(
			withDuration: 0.2,
			delay: 0,
			options: .curveEaseInOut,
			animations: {
				self.backgroundBlurView.effect = nil
				self.popupView.alpha = 0
				self.view.layoutIfNeeded()
		}) { _ in
			self.backgroundBlurView.isHidden = true
			self.popupView.isHidden = true
			self.capturedPhotoImageView.image = nil
			self.idLabel.text = "Identifying..."
			self.idLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
			self.idLabel.textColor = UIColor.white.withAlphaComponent(0.6)
			self.animalButton.setImage(nil, for: .normal)
			self.captureButton.isUserInteractionEnabled = true
		}
	}
}

/// Capture delegate
extension CameraViewController: SwiftyCamViewControllerDelegate {
	func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
		// Show captured image
		capturedPhotoImageView.image = photo
		backgroundBlurView.isHidden = false
		popupView.isHidden = false
		loadingView.startAnimating()
		self.view.layoutIfNeeded()
		UIView.animate(
			withDuration: 0.2,
			delay: 0,
			options: .curveEaseInOut,
			animations: {
				self.backgroundBlurView.effect = UIBlurEffect(style: .dark)
				self.popupView.alpha = 1
				self.view.layoutIfNeeded()
		})
		// Identify the animal
		dataManager.identifyAnimal(in: photo) { animalType in
			var animal: Animal!
			switch animalType {
			case .cat:
				animal = self.cat
			case .dog:
				animal = self.dog
			case .baby:
				animal = self.baby
			case .biggestBaby:
				animal = self.biggestBaby
			}
			self.view.layoutIfNeeded()
			UIView.animate(
				withDuration: 0.1,
				delay: 0,
				options: .curveEaseIn,
				animations: {
					self.closeButton.alpha = 0
					self.idLabel.alpha = 0
					self.loadingView.alpha = 0
					self.view.layoutIfNeeded()
			}) { _ in
				self.idLabel.text = animal.description
				self.idLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
				self.idLabel.textColor = UIColor.white
				self.animalButton.setImage(animal.image, for: .normal)
				self.loadingView.stopAnimating()
				self.speechSynthesizer.speak(animal.utterance)
				self.isIdentifying = false
			}
			self.view.layoutIfNeeded()
			UIView.animate(
				withDuration: 0.13,
				delay: 0.12,
				options: .curveEaseIn,
				animations: {
					self.closeButton.alpha = 1
					self.idLabel.alpha = 1
					self.loadingView.alpha = 1
					self.view.layoutIfNeeded()
			})
		}
	}
}
