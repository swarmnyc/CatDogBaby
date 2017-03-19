//
//  CloseButton.swift
//  CatDogBaby
//
//  Created by William Robinson on 3/18/17.
//  Copyright © 2017 William Robinson. All rights reserved.
//

import UIKit

class CloseButton: UIButton {
	
	// Delegation
	var animalIdentificationDelegate: AnimalIdentificationProtocol
	
	// Initialization
	init(_ animalIdentificationDelegate: AnimalIdentificationProtocol) {
		self.animalIdentificationDelegate = animalIdentificationDelegate
		super.init(frame: CGRect.zero)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	// Drawing
	override func draw(_ rect: CGRect) {
		if animalIdentificationDelegate.isIdentifying {
			StyleKit.drawCloseButton(scale: 0.7, rotation: 0)
		} else {
			StyleKit.drawCloseButton(scale: 1, rotation: 0)
		}
	}
}
