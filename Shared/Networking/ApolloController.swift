//
//  ApolloController.swift
//  VegMeal (iOS)
//
//  Created by Travis Gerrard on 9/16/20.
//

import CoreData
import Apollo
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
    @AppStorage("token", store: UserDefaults.shared) var token = ""
    @AppStorage("isLogged", store: UserDefaults.shared) var isLogged = false

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Swift.Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        if isLogged {
            request.addHeader(name: "Authorization", value: "Bearer \(token)")
        }

        chain.proceedAsync(request: request,
                           response: response,
                           completion: completion)
        
    }
}

class UserManagementInterceptor: ApolloInterceptor {
    @AppStorage("token", store: UserDefaults.shared) var token = ""

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
