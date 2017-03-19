//
//  StyleKit.swift
//  CatDogBaby
//
//  Created by William Robinson on 3/19/17.
//  Copyright © 2017 WilliamRobinson. All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//



import UIKit

public class StyleKit : NSObject {

    //// Cache

    private struct Cache {
        static let transparentWhite: UIColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.338)
        static let transparentGray: UIColor = UIColor(red: 0.251, green: 0.232, blue: 0.232, alpha: 0.433)
    }

    //// Colors

    public dynamic class var transparentWhite: UIColor { return Cache.transparentWhite }
    public dynamic class var transparentGray: UIColor { return Cache.transparentGray }

    //// Drawing Methods

    public dynamic class func drawShutterButton(scaleCaptureButton: CGFloat = 1) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!


        //// Shadow Declarations
        let captureButtonOuterShadow = NSShadow()
        captureButtonOuterShadow.shadowColor = UIColor.black.withAlphaComponent(0.2)
        captureButtonOuterShadow.shadowOffset = CGSize(width: 0, height: 0)
        captureButtonOuterShadow.shadowBlurRadius = 12
        let captureButtonInnerShadow = NSShadow()
        captureButtonInnerShadow.shadowColor = UIColor.black.withAlphaComponent(0.2)
        captureButtonInnerShadow.shadowOffset = CGSize(width: 3, height: 3)
        captureButtonInnerShadow.shadowBlurRadius = 12

        //// Variable Declarations
        let scaleAspectCaptureButton: CGFloat = scaleCaptureButton
        let opacityCaptureButton: CGFloat = scaleCaptureButton

        //// Oval Drawing
        context.saveGState()
        context.translateBy(x: 50, y: 50)
        context.scaleBy(x: scaleCaptureButton, y: scaleAspectCaptureButton)

        context.saveGState()
        context.setAlpha(opacityCaptureButton)
        context.beginTransparencyLayer(auxiliaryInfo: nil)

        let ovalPath = UIBezierPath(ovalIn: CGRect(x: -36.5, y: -36, width: 72.5, height: 72.5))
        StyleKit.transparentWhite.setFill()
        ovalPath.fill()

        ////// Oval Inner Shadow
        context.saveGState()
        context.clip(to: ovalPath.bounds)
        context.setShadow(offset: CGSize.zero, blur: 0)
        context.setAlpha((captureButtonInnerShadow.shadowColor as! UIColor).cgColor.alpha)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        let ovalOpaqueShadow = (captureButtonInnerShadow.shadowColor as! UIColor).withAlphaComponent(1)
        context.setShadow(offset: captureButtonInnerShadow.shadowOffset, blur: captureButtonInnerShadow.shadowBlurRadius, color: ovalOpaqueShadow.cgColor)
        context.setBlendMode(.sourceOut)
        context.beginTransparencyLayer(auxiliaryInfo: nil)

        ovalOpaqueShadow.setFill()
        ovalPath.fill()

        context.endTransparencyLayer()
        context.endTransparencyLayer()
        context.restoreGState()

        context.saveGState()
        context.setShadow(offset: captureButtonOuterShadow.shadowOffset, blur: captureButtonOuterShadow.shadowBlurRadius, color: (captureButtonOuterShadow.shadowColor as! UIColor).cgColor)
        UIColor.white.setStroke()
        ovalPath.lineWidth = 8
        ovalPath.stroke()
        context.restoreGState()

        context.endTransparencyLayer()
        context.restoreGState()

        context.restoreGState()
    }

    public dynamic class func drawCloseButton(scaleCloseButton: CGFloat = 1, rotation: CGFloat = 0) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        //// Color Declarations
        let white = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)

        //// Shadow Declarations
        let closeShadow = NSShadow()
        closeShadow.shadowColor = UIColor.black.withAlphaComponent(0.5)
        closeShadow.shadowOffset = CGSize(width: 0, height: 0)
        closeShadow.shadowBlurRadius = 6

        //// Variable Declarations
        let scaleAspectCloseButton: CGFloat = scaleCloseButton

        //// Bezier Drawing
        context.saveGState()
        context.translateBy(x: 35, y: 45)
        context.rotate(by: -rotation * CGFloat.pi/180)
        context.scaleBy(x: scaleCloseButton, y: scaleAspectCloseButton)

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 8.14, y: -9))
        bezierPath.addLine(to: CGPoint(x: 9, y: -8.14))
        bezierPath.addCurve(to: CGPoint(x: 0.86, y: -0), controlPoint1: CGPoint(x: 9, y: -8.14), controlPoint2: CGPoint(x: 5, y: -4.14))
        bezierPath.addCurve(to: CGPoint(x: 9, y: 8.14), controlPoint1: CGPoint(x: 5, y: 4.14), controlPoint2: CGPoint(x: 9, y: 8.14))
        bezierPath.addLine(to: CGPoint(x: 8.14, y: 9))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 0.86), controlPoint1: CGPoint(x: 8.14, y: 9), controlPoint2: CGPoint(x: 4.14, y: 5))
        bezierPath.addCurve(to: CGPoint(x: -8.14, y: 9), controlPoint1: CGPoint(x: -4.14, y: 5), controlPoint2: CGPoint(x: -8.14, y: 9))
        bezierPath.addLine(to: CGPoint(x: -9, y: 8.14))
        bezierPath.addCurve(to: CGPoint(x: -0.86, y: 0), controlPoint1: CGPoint(x: -9, y: 8.14), controlPoint2: CGPoint(x: -5, y: 4.14))
        bezierPath.addCurve(to: CGPoint(x: -9, y: -8.14), controlPoint1: CGPoint(x: -5, y: -4.14), controlPoint2: CGPoint(x: -9, y: -8.14))
        bezierPath.addLine(to: CGPoint(x: -8.14, y: -9))
        bezierPath.addCurve(to: CGPoint(x: -0, y: -0.86), controlPoint1: CGPoint(x: -8.14, y: -9), controlPoint2: CGPoint(x: -4.14, y: -5))
        bezierPath.addCurve(to: CGPoint(x: 8.14, y: -9), controlPoint1: CGPoint(x: 3.05, y: -3.9), controlPoint2: CGPoint(x: 8.14, y: -9))
        bezierPath.addLine(to: CGPoint(x: 8.14, y: -9))
        bezierPath.close()
        context.saveGState()
        context.setShadow(offset: closeShadow.shadowOffset, blur: closeShadow.shadowBlurRadius, color: (closeShadow.shadowColor as! UIColor).cgColor)
        white.setFill()
        bezierPath.fill()
        context.restoreGState()


        context.restoreGState()
    }

}
