//
//  Animal.swift
//  CatDogBaby
//
//  Created by William Robinson on 3/18/17.
//  Copyright © 2017 William Robinson. All rights reserved.
//

import UIKit
import AVFoundation

enum AnimalType {
	case cat, dog, baby, biggestBaby
}

struct Animal {
	var image: UIImage
	var utterance: AVSpeechUtterance
	var description: String
}
