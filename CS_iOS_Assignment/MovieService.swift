//
//  MovieService.swift
//  CS_iOS_Assignment
//
//  Copyright © 2019 Backbase. All rights reserved.
//

import Foundation
import UIKit

class MovieService {
    
    let defaultSession: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.defaultSession = session
    }
    
    var dataTask: URLSessionDataTask?
    
    typealias movieResponseHandler = (Result<(movies: [Movie], totalPages: Int) , AppError>) -> Void
    typealias imageDownloadHandler = (Result<UIImage, AppError>) -> Void
    typealias movieDetailResponseHandler = (Result<MovieDetails, AppError>) -> Void
        
    func fetchMovies(for url: URL, completion: @escaping movieResponseHandler) {
        self.dataTask?.cancel()
        
        self.dataTask = self.defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                completion(.failure(.customError(description: "DataTask error: " + error.localizedDescription)))
            } else if let jsonData = data {
                
                do {
                    let response = try JSONDecoder().decode(MovieDBResponse.self, from: jsonData)
                    let movies = response.movies
                    completion(.success((movies, response.totalPages)))
                } catch _ as NSError {
                    completion(.failure(.parsingError))
                }
                
            }
        } as? URLSessionDataTask
        
        self.dataTask?.resume()
    }
    
    func fetchMovieDetails(for url: URL, completion: @escaping movieDetailResponseHandler) {
        self.dataTask?.cancel()
        
        self.dataTask = self.defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                completion(.failure(.customError(description: "DataTask error: " + error.localizedDescription)))
            } else if let jsonData = data {
                
                
                do {
                    let movie = try JSONDecoder().decode(MovieDetails.self, from: jsonData)
                    completion(.success(movie))
                } catch _ as NSError {
                    completion(.failure(.parsingError))
                }
                
            }
        } as? URLSessionDataTask
        
        self.dataTask?.resume()
    }
    
    /**
     Download Image from server.
     
     - parameters:
        - url: URL to download image.
        - completionHandler: Completion handler to notify caller after response came.
     
     */
    
    func downloadMovieImage(url: URL, completionHandler: @escaping imageDownloadHandler) {
        
        self.dataTask?.cancel()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        if  let image = appDelegate.imageCache.object(forKey: NSString(string: url.lastPathComponent)) {
            completionHandler(.success(image))
        } else {
            
            self.dataTask = self.defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                if let error = error {
                    completionHandler(.failure(.customError(description: "DataTask error: " + error.localizedDescription)))
                } else if let imageData = data {
                    
                    guard let movieImage = UIImage(data: imageData) else {
                        completionHandler(.failure(.customError(description: "Unable to download Image.")))
                        return
                    }
                    
                    appDelegate.imageCache.setObject(movieImage, forKey: NSString(string: url.lastPathComponent))
                    completionHandler(.success(movieImage))
                }
            } as? URLSessionDataTask
            
            self.dataTask?.resume()
        }
    }
}
