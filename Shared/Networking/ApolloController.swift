//
//  ApolloController.swift
//  VegMeal (iOS)
//
//  Created by Travis Gerrard on 9/16/20.
//

import CoreData
import Apollo
import ApolloSQLite
import SwiftUI


class ApolloController {
    static let shared = ApolloController()
    
    // Configure the network transport to use the singleton as the delegate.
    private(set) lazy var apollo: ApolloClient = {
        
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(client: client, store: store)
//        let url = URL(string: "http://localhost:3000/admin/api")!
        let url = URL(string: "https://api.veggily.app/admin/api")!
        let transport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                     endpointURL: url)
        return ApolloClient(networkTransport: transport, store: store)
        
        //        let documentsPath = NSSearchPathForDirectoriesInDomains(
        //            .documentDirectory,
        //            .userDomainMask,
        //            true).first!
        //        let documentsURL = URL(fileURLWithPath: documentsPath)
        //        let sqliteFileURL = documentsURL.appendingPathComponent("db.sqlite")
        //
        //
        //        do {
        //            let sqliteCache = try SQLiteNormalizedCache(fileURL: sqliteFileURL)
        //            let store = ApolloStore(cache: sqliteCache)
        ////            let network = RequestChainNetworkTransport(interceptorProvider: LegacyInterceptorProvider(store: store),
        ////                                                       endpointURL: URL(string: "https://api.veggily.app/admin/api")!)
        //            let network = RequestChainNetworkTransport(interceptorProvider:LegacyInterceptorProvider(store: store),
        //                                                       endpointURL: URL(string: "http://localhost:3000/admin/api")!)
        //
        //            return ApolloClient(networkTransport: network, store: store)
        //        } catch {
        ////            return ApolloClient(url: URL(string: "https://api.veggily.app/admin/api")!)
        //            return ApolloClient(url: URL(string: "http://localhost:3000/admin/api")!)
        //        }
    }()
}

class NetworkInterceptorProvider: LegacyInterceptorProvider {
    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(CustomInterceptor(), at: 0)
        
        return interceptors
    }
}

class CustomInterceptor: ApolloInterceptor {
    @AppStorage("token") var token = ""
    @AppStorage("isLogged") var isLogged = false
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Swift.Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        if isLogged {
            request.addHeader(name: "Authorization", value: "Bearer \(token)")
        }
//        print("request :\(request)")
//        print("response :\(String(describing: response))")
        
        chain.proceedAsync(request: request,
                           response: response,
                           completion: completion)
        
    }
}

class UserManagementInterceptor: ApolloInterceptor {
    @AppStorage("token") var token = ""
    
    
    
    enum UserError: Error {
        case noUserLoggedIn
    }
    
    /// Helper function to add the token then move on to the next step
    private func addTokenAndProceed<Operation: GraphQLOperation>(
        _ token: String,
        to request: HTTPRequest<Operation>,
        chain: RequestChain,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        
        print("TOKEN!, TOKEN")
        
        request.addHeader(name: "Authorization", value: "Bearer \(token)")
        chain.proceedAsync(request: request,
                           response: response,
                           completion: completion)
    }
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        
        print("TOKEN!, TOKEN, TOKEN")
        
        // If we've gotten here, there is a token!
        if token != "" {
            // We don't need to wait for renewal, add token and move on
            self.addTokenAndProceed(token,
                                    to: request,
                                    chain: chain,
                                    response: response,
                                    completion: completion)
        }
    }
}
//
//extension ApolloController: HTTPNetworkTransportPreflightDelegate {
//    
//    func networkTransport(_ networkTransport: HTTPNetworkTransport,
//                          shouldSend request: URLRequest) -> Bool {
//        // If there's an authenticated user, send the request. If not, don't.
//        return true
//    }
//    
//    func networkTransport(_ networkTransport: HTTPNetworkTransport,
//                          willSend request: inout URLRequest) {
//        
//        
//        if UserDefaults.standard.bool(forKey: "isLogged") {
//            // Get the existing headers, or create new ones if they're nil
//            var headers = request.allHTTPHeaderFields ?? [String: String]()
////            print("Token!")
////            print(UserDefaults.standard.string(forKey: "token") ?? "")
//
//            
//            // Add any new headers you need
//            headers["Authorization"] = "Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")"
//            
////            print("Headers: \(headers)")
//            // Re-assign the updated headers to the request.
//            request.allHTTPHeaderFields = headers
//        }
//        
//        
////        print("Outgoing request: \(request)")
//    }
//}


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
