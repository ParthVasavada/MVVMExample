//
//  AppUtilities.swift
//  CS_iOS_Assignment
//
//  Created by Parth Vasavada on 27/04/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation
import UIKit
enum AppError: Error {
    case parsingError
    case customError(description: String)
}

extension AppError: Equatable {}

extension UIColor {
    static var  darkGreenRatingColor: UIColor {
        return UIColor(red: 29.0/255.0, green: 69.0/255.0, blue: 43.0/255.0, alpha: 1.0)
    }
    
    static var  yellowRatingColor: UIColor {
        return UIColor(red: 65.0/255.0, green: 62.0/255.0, blue: 23.0/255.0, alpha: 1.0)
    }
}

protocol DataBinding {
    associatedtype BindingType
    var dataBinding: BindingType { get set }
}


protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}


protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}
