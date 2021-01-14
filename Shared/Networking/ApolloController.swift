//
//  ApolloController.swift
//  VegMeal (iOS)
//
//  Created by Travis Gerrard on 9/16/20.
//

import Apollo
import Foundation



class ApolloController {
    static let shared = ApolloController()
    
    // Configure the network transport to use the singleton as the delegate.
    private lazy var networkTransport: HTTPNetworkTransport = {
//        let transport = HTTPNetworkTransport(url: URL(string: "https://api.veggily.app/admin/api")!)
        let transport = HTTPNetworkTransport(url: URL(string: "http://localhost:3000/admin/api")!)
        transport.delegate = self
        return transport
    }()
    

    // Use the configured network transport in your Apollo client.
    private(set) lazy var apollo = ApolloClient(networkTransport: self.networkTransport)
}

extension ApolloController: HTTPNetworkTransportPreflightDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          shouldSend request: URLRequest) -> Bool {
        // If there's an authenticated user, send the request. If not, don't.
        return true
    }
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          willSend request: inout URLRequest) {
        
        
        if UserDefaults.standard.bool(forKey: "isLogged") {
            // Get the existing headers, or create new ones if they're nil
            var headers = request.allHTTPHeaderFields ?? [String: String]()
//            print("Token!")
//            print(UserDefaults.standard.string(forKey: "token") ?? "")

            
            // Add any new headers you need
            headers["Authorization"] = "Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")"
            
//            print("Headers: \(headers)")
            // Re-assign the updated headers to the request.
            request.allHTTPHeaderFields = headers
        }
        
        
//        print("Outgoing request: \(request)")
    }
}


//// MARK: - Task Completed Delegate
//
//extension ApolloController: HTTPNetworkTransportTaskCompletedDelegate {
//  func networkTransport(_ networkTransport: HTTPNetworkTransport,
//                        didCompleteRawTaskForRequest request: URLRequest,
//                        withData data: Data?,
//                        response: URLResponse?,
//                        error: Error?) {
//    print("Raw task completed for request: \(request)")
//
//    if let error = error {
//        print("Error: \(error)")
//    }
//
//    if let response = response {
//        print("Response: \(response)")
//    } else {
//        print("No URL Response received!")
//    }
//
//    if let data = data {
//        print("Data: \(String(describing: String(bytes: data, encoding: .utf8)))")
//    } else {
//        print("No data received!")
//    }
//  }
//}

// MARK: - Retry Delegate

//extension ApolloController: HTTPNetworkTransportRetryDelegate {
//
//  func networkTransport(_ networkTransport: HTTPNetworkTransport,
//                        receivedError error: Error,
//                        for request: URLRequest,
//                        response: URLResponse?,
//                        continueHandler: @escaping (_ action: HTTPNetworkTransport.ContinueAction) -> Void) {
//    // Check if the error and/or response you've received are something that requires authentication
//    guard UserManager.shared.requiresReAuthentication(basedOn: error, response: response) else {
//      // This is not something this application can handle, do not retry.
//      continueHandler(.fail(error))
//      return
//    }
//
//    // Attempt to re-authenticate asynchronously
//    UserManager.shared.reAuthenticate { (reAuthenticateError: Error?) in
//      // If re-authentication succeeded, try again. If it didn't, don't.
//      if let reAuthenticateError = reAuthenticateError {
//        continueHandler(.fail(reAuthenticateError)) // Will return re authenticate error to query callback
//        // or (depending what error you want to get to callback)
//        continueHandler(.fail(error)) // Will return original error
//      } else {
//        continueHandler(.retry)
//      }
//    }
//  }
//}
