//
//  DataManager.swift
//  CatDogBaby
//
//  Created by William Robinson on 3/18/17.
//  Copyright © 2017 William Robinson. All rights reserved.
//

import UIKit
import SwiftyJSON

class DataManager {
	
	// Properties
	lazy var url: URL = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(Secret.googleAPIKey)")!
	var timer: Timer?
	var didTimeout: Bool = false
	
	/// Gets image annotations
	func identifyAnimal(in image: UIImage, completion: @escaping (AnimalType) -> Void) {
		let imageBase64String: String = resize(image: image).base64EncodedString(options: .endLineWithCarriageReturn)
		var request: URLRequest = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
		let jsonRequest: [String : [String : Any]] = [
			"requests" : [
				"image" : [
					"content" : imageBase64String
				],
				"features" : [
					["type" : "LABEL_DETECTION",
					 "maxResults" : 10]
				]
			]
		]
		request.httpBody = try! JSON(jsonDictionary: jsonRequest).rawData()
		URLSession.shared
			.dataTask(with: request) { data, response, error in
				guard !self.didTimeout else { return }
				guard let data = data, error == nil else {
					DispatchQueue.main.async {
						print("Error unwrapping annotation response data")
						self.timer?.invalidate()
						completion(.baby)
					}
					return
				}
				let labelAnnotations: JSON = JSON(data: data)["responses"][0]["labelAnnotations"]
				guard !labelAnnotations.isEmpty else {
					DispatchQueue.main.async {
						print("No label annotions")
						self.timer?.invalidate()
						completion(.baby)
					}
					return
				}
				var labels: [String] = []
				for index in 0..<labelAnnotations.count {
					let label = labelAnnotations[index]["description"].stringValue
					labels.append(label)
				}
				DispatchQueue.main.async {
					self.timer?.invalidate()
					completion(self.parse(labels))
				}
			}.resume()
		didTimeout = false
		timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
			DispatchQueue.main.async {
				self.didTimeout = true
				completion(.baby)
				return
			}
		}
	}
	
	/// Parses image annotations
	func parse(_ labels: [String]) -> AnimalType{
		for label in labels {
			if label.contains("cat") {
				return .cat
			} else if label.contains("dog") {
				return .dog
			} else if label.contains("hair") {
				return .biggestBaby
			}
		}
		return .baby
	}
	
	/// Downsizes images before making request against Google Vision API
	func resize(image: UIImage) -> Data {
		let size: CGSize = CGSize(width: 200, height: image.size.height / image.size.width * 200)
		UIGraphicsBeginImageContext(size)
		image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
		let resizedImageData: Data = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext()!)!
		UIGraphicsEndImageContext()
		return resizedImageData
	}
}
