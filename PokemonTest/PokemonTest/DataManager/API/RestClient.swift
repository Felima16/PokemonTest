//
//  RestClient.swift
//  PokemonTest
//
//  Created by Fernanda de Lima on 05/03/22.
//

import Foundation

class RestClient: ServiceInput {
    var serviceHandler: ServiceOutput?
    let debug = true
    
    func get<T>(obj: T.Type,
                url: Endpoint)
    where T : Decodable {
        if (self.debug) {
            print("==========> GET")
            print("URL: \(url.path)")
        }
        
        var request = URLRequest(url: URL(string: url.path)!)
        request.httpMethod = "GET"
        request.addValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        let task = session.dataTask(with: request,
                                    completionHandler:
                                        { data,
                                          response,
                                          error -> Void in
            do {
                if (self.debug) {
                    guard let dataR = data else { return }
                    print("==========> RESPONSE DATA")
                    print(String(data: dataR, encoding: .utf8)!)
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if (self.debug) {
                        print("==========> RESPONSE CODE")
                        print(httpResponse.statusCode)
                    }
                    
                    switch httpResponse.statusCode {
                    case 200:
                        let jsonDecoder = JSONDecoder()
                        let json = try jsonDecoder.decode(obj,
                                                          from: data!)
                        if (self.debug) {
                            print("==========> SAIDA")
                            print(json)
                        }
                        self.serviceHandler?
                            .onResult(json)
                    case 10:
                        self.serviceHandler?
                            .onError(.notAvailable)
                    case 100:
                        self.serviceHandler?
                            .onError(.invalidAPIKey)
                    case 105:
                        self.serviceHandler?
                            .onError(.serviceCurrentlyUnavailable)
                    case 116:
                        self.serviceHandler?
                            .onError(.badURLFound)
                    default:
                        self.serviceHandler?
                            .onError(.genericError)
                    }
                }
                
            } catch let error {
                if (self.debug) {
                    print("==========> EXCEPTION OBJECT JSON")
                    print(error)
                    self.serviceHandler?
                        .onError(.noTransformObj)
                }
            }
        })
        task.resume()
    }
    
    func getData(from url: String) {
        if (self.debug) {
            print("==========> DOWNLOAD STARTED")
            print("URL: \(url)")
        }
        let urlPath = URL(string: url)!
        URLSession.shared.dataTask(with: urlPath) { data, response, error in
            guard let data = data, error == nil else {
                self.serviceHandler?.onError(.downloadError)
                return
            }
            if (self.debug) {
                print(response?.suggestedFilename ?? urlPath.lastPathComponent)
                print("==========> DOWNLOAD FINISHED")
            }
            self.serviceHandler?.onResultData(data)
        }.resume()
    }
}
