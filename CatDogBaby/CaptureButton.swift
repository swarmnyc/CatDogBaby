//
//  CaptureButton.swift
//  CatDogBaby
//
//  Created by William Robinson on 3/18/17.
//  Copyright © 2017 William Robinson. All rights reserved.
//

import UIKit

class CaptureButton: UIButton {
	
	// Properties
	var captureDelegate: CaptureProtocol
	var scale: CGFloat = 1
	var displayLink: CADisplayLink?
	
	// Initialization
	init(_ captureDelegate: CaptureProtocol) {
		self.captureDelegate = captureDelegate
		super.init(frame: CGRect.zero)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	// Drawing
	override func draw(_ rect: CGRect) {
		StyleKit.drawShutterButton(scaleCaptureButton: scale)
	}
	
	// Animate
	func setUpAnimation() {
		displayLink = CADisplayLink(target: self, selector: #selector(changeScale))
		displayLink?.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
	}
	
	// Actions
	func changeScale() {
		if captureDelegate.isCaptureTouchDown {
			guard scale > 0.9 else {
				displayLink?.invalidate()
				return
			}
			scale -= 0.05
			setNeedsDisplay()
		} else {
			guard scale < 1 else {
				displayLink?.invalidate()
				return
			}
			scale += 0.05
			setNeedsDisplay()
		}
	}
}
