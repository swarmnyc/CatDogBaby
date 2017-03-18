//
//  ViewController.swift
//  CatDogBaby
//
//  Created by William Robinson on 3/17/17.
//  Copyright © 2017 William Robinson. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class ViewController: UIViewController {

	// Subviews
	lazy var catButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setTitle("cat", for: .normal)
		button.titleLabel!.font = UIFont.systemFont(ofSize: 50, weight: UIFontWeightBlack)
		button.titleLabel!.layer.shadowRadius = 20
		button.titleLabel!.layer.shadowOffset = CGSize(width: 0, height: 0)
		button.titleLabel!.layer.shadowOpacity = 0.2
		button.setBackgroundImage(#imageLiteral(resourceName: "TubeCat"), for: .normal)
		button.imageView!.contentMode = .scaleAspectFill
		button.addTarget(self, action: #selector(catButtonTouched), for: .touchUpInside)
		return button
	}()
	lazy var dogButton: UIButton = {
		let button = UIButton()
		button.setTitle("dog", for: .normal)
		button.titleLabel!.font = UIFont.systemFont(ofSize: 50, weight: UIFontWeightBlack)
		button.titleLabel!.layer.shadowRadius = 20
		button.titleLabel!.layer.shadowOffset = CGSize(width: 0, height: 0)
		button.titleLabel!.layer.shadowOpacity = 0.2
		button.setBackgroundImage(#imageLiteral(resourceName: "HappyDog"), for: .normal)
		button.imageView!.contentMode = .scaleAspectFill
		button.addTarget(self, action: #selector(dogButtonTouched), for: .touchUpInside)
		return button
	}()
	lazy var babyButton: UIButton = {
		let button = UIButton()
		button.setTitle("baby", for: .normal)
		button.titleLabel!.font = UIFont.systemFont(ofSize: 50, weight: UIFontWeightBlack)
		button.titleLabel!.layer.shadowRadius = 20
		button.titleLabel!.layer.shadowOffset = CGSize(width: 0, height: 0)
		button.titleLabel!.layer.shadowOpacity = 0.2
		button.setBackgroundImage(#imageLiteral(resourceName: "ConfusedBaby"), for: .normal)
		button.imageView!.contentMode = .scaleAspectFill
		button.addTarget(self, action: #selector(babyButtonTouched), for: .touchUpInside)
		return button
	}()
	
	// Speech
	lazy var speechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
	
	// Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(catButton)
		view.addSubview(dogButton)
		view.addSubview(babyButton)
		catButton.snp.makeConstraints {
			$0.top.left.right.equalToSuperview()
			$0.height.equalToSuperview().dividedBy(3)
		}
		dogButton.snp.makeConstraints {
			$0.top.equalTo(catButton.snp.bottom)
			$0.left.right.equalToSuperview()
			$0.bottom.equalTo(babyButton.snp.top)
		}
		babyButton.snp.makeConstraints {
			$0.left.bottom.right.equalToSuperview()
			$0.height.equalToSuperview().dividedBy(3)
		}
	}
	
	// Actions
	func catButtonTouched() {
		speechSynthesizer.
		speechSynthesizer.speak(AVSpeechUtterance(string: "Yep that's a cat!"))
	}
	func dogButtonTouched() {
		speechSynthesizer.pauseSpeaking(at: .immediate)
		speechSynthesizer.speak(AVSpeechUtterance(string: "This animal is a dog!"))
	}
	func babyButtonTouched() {
		speechSynthesizer.pauseSpeaking(at: .immediate)
		speechSynthesizer.speak(AVSpeechUtterance(string: "That is one fat baby..."))
	}
}

