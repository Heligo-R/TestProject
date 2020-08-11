//
//  StoryboardViewController.swift
//  TestProject
//
//  Created by Oleg on 06.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
import WebKit
import RxSwift

final class SupportViewController: UIViewController {
    @IBOutlet private weak var penLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    private let apiManager = ApiManager()
    private let localRepo = LocalRepo()
    
    override func viewDidLoad() {
        let loginForm = LoginForm(login: "user@user.user", password: "user")
        let authObserver: Observable<(response: HTTPURLResponse, result: AuthData)>? = apiManager.postRequest(endpoint: "/auth/login", toPost: loginForm)
        authObserver?.observeOn(MainScheduler.instance).subscribe(onNext: { _, result  in
            let entity = SimpleEntity()
            entity.token = "authorizationKey"
            entity.value = String(result.id)
            self.localRepo.addEntity(entity)
        }).disposed(by: disposeBag)
        
        apiManager.getRequest(endpoint: "/pen/get/1", authorized: true)?.observeOn(MainScheduler.instance).subscribe(onNext: { _, result  in
            self.penLabel.text = (result as Pen).pen_id_name
        }).disposed(by: disposeBag)
    }
}
