//
//  Helper.swift
//  CS_iOS_AssignmentTests
//
//  Created by Parth Vasavada on 01/05/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

class Helper {
    
    let mockURL = "mockURL"
    
    let invalidAPIKeyResponse = "{\"status_code\":7,\"status_message\":\"Invalid API key: You must be granted a valid key.\",\"success\":false}"
    
    private func JsonData(for file: String) -> Data? {
        
        if let jsonFilePath = Bundle.main.path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            
            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                return jsonData
            }
        }
        return nil
    }
    
    func MockSession(fromJsonFile file: String,
                     andStatusCode code: Int = 200,
                     andError error: Error? = nil) -> MockURLSession? {
        
        let data = self.JsonData(for: file)
        let response = HTTPURLResponse(url: URL(fileURLWithPath: self.mockURL), statusCode: code, httpVersion: nil, headerFields: nil)
        return MockURLSession(completionHandler: (data, response, error))
    }
}
