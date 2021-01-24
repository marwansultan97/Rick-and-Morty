//
//  APIService.swift
//  Rick and Morty
//
//  Created by Marwan Osama on 1/21/21.
//

import Foundation
import Alamofire

class APIService {
        
    
    static let shared = APIService()
    
    func fetchData<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, completion: @escaping(T?, Error?)-> Void) {
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case.success(_):
                guard let data = response.data else { return }
                do {
                    let jsonData = try JSONDecoder().decode(T.self, from: data)
                    completion(jsonData, nil)
                } catch let jsonErr {
                    completion(nil, jsonErr)
                }
            case.failure(let err):
                completion(nil, err)
            }
        }
        
    }
    
    
    
    
}
