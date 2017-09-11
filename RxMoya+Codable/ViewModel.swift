//
//  ViewModel.swift
//  RxMoya+Codable
//
//  Created by Imairi Yosuke on 2017/09/11.
//  Copyright © 2017年 Imairi Yosuke. All rights reserved.
//

import UIKit
import Moya
import RxMoya
import RxSwift
import RxCocoa

class ViewModel {
    struct Input {
        let tapButton: Observable<Void>
    }
    
    let didFinishGetUsers: Observable<[User]>
    
    fileprivate let provider: MoyaProvider<UserAPI> = {
        let stubClosure = { (target: UserAPI) -> StubBehavior in
            return .never
        }
        let networkLoggerPlugin = NetworkLoggerPlugin(cURL: true)
        let plugins = [networkLoggerPlugin]
        return MoyaProvider<UserAPI>(stubClosure: stubClosure, plugins: plugins)
    }()
    
    private let disposeBag = DisposeBag()
    
    init(input: Input) {
        let didFinishGetUsersSubject = PublishSubject<[User]>()
        
        didFinishGetUsers = didFinishGetUsersSubject.asObservable()
        
        input.tapButton
            .flatMap { self.provider.rx.request(UserAPI.fetch) }
            .flatMap({ (response) -> Observable<[User]> in
                return Observable<[User]>.create({ (observer) -> Disposable in
                    do {
                        let decoder = JSONDecoder()
                        let users = try decoder.decode([User].self, from: response.data)
                        observer.onNext(users)
                    } catch(let error) {
                        observer.onError(error)
                    }
                    return Disposables.create()
                })
            })
            .bind(to: didFinishGetUsersSubject)
            .disposed(by: disposeBag)
    }
}
