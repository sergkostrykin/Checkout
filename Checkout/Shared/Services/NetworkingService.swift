//
//  NetworkingService.swift
//  Checkout
//
//  Created by Sergiy Kostrykin on 31/08/2022.
//

import Foundation
import Alamofire

class NetworkingService {
        
    class func pay(creditCard: CreditCard, completion: ((String?, Error?)->())?) {
        let params = PayRequest(creditCard: creditCard)
        let url = Constants.API.baseUrl.appendingPathComponent("pay")
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default).validate().responseDecodable(of: PayResponse.self) { response in
            switch response.result {
            case .success(let result):
                completion?(result.url, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
}
