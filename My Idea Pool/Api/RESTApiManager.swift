//
//  RESTApiManager.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-30.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import Foundation

final class RESTApiManager {
    
    static let sharedInstance = RESTApiManager()
    
    // Asynchonous function for api calls.
    func makeAPICall(endPoint: String, json: Data?, requestType: String, authToken: String?, completion: @escaping (Data?, String?) -> ()){
        
        guard let url = URL(string:  Endpoints.host.rawValue + endPoint) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = requestType
            request.addValue("application/json",forHTTPHeaderField: "content-type")
            request.httpBody = json
            if authToken != nil {
                request.setValue(authToken, forHTTPHeaderField: "X-Access-Token")
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                // Unreachable
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    completion(nil, error?.localizedDescription ?? "No data")
                    return
                }
                let httpResponse = response as! HTTPURLResponse
                
                // Good data
                if httpResponse.statusCode >= 200 && httpResponse.statusCode <= 209 {
                    print(httpResponse.statusCode)
                    completion(data, nil)
                }
                // Bad data
                else {
                    print(httpResponse.statusCode)
                    let errorResponse = String(decoding: data, as: UTF8.self)
                    completion(nil, errorResponse)
                    
                }
            }
            task.resume()
    }
    // Synchronous - Only used when the app is initially loaded
    func prepareSynchonousRequest(endPoint: String, json: Data, requestType: String) -> String? {
        
        guard let url = URL(string:  Endpoints.host.rawValue + endPoint) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType
        request.addValue("application/json",forHTTPHeaderField: "content-type")
        request.httpBody = json
        
        let (data, response, error) = URLSession.shared.synchronousDataTask(with: request)
        let httpResponse = response as! HTTPURLResponse
        print(httpResponse.statusCode)
        
        let string = String(data: data!, encoding: String.Encoding.utf8)
        print(string!)
        
        guard data != nil, error == nil else { return nil }
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode <= 209 else {
            print(httpResponse.statusCode)
            return nil
        }
        
        var authTokens: AuthenticationTokens!
        do { authTokens = try JSONDecoder().decode(AuthenticationTokens.self, from: data!) }
        catch {
            print("Could not decode JSON")
            return nil
        }
        return authTokens.jwt
    }
}

extension URLSession {
    
    func synchronousDataTask(with request: URLRequest) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: request) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return (data, response, error)
    }
}
