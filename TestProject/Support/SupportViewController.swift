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
    @IBOutlet private weak var imageView: UIImageView!
    
    private let disposeBag = DisposeBag()
    private let api = Api()
    private let localRepo = LocalRepo()
    
    override func viewDidLoad() {
        let loginData = LoginData(login: "user@user.user", password: "user")
        api.login(with: loginData).flatMap{ result -> Observable<[Pen]> in
            UserDefaults.standard.set(result.token, forKey: DefaultNames.authToken)
            print(result)
            return self.api.getPensList()
        }.flatMap{ pensList -> Observable<Pen> in
            return self.api.getPen(byId: pensList[0].id)
        }.subscribe{ event in
            switch event {
            case .next(let penResult):
                print(penResult)
            case .error(let error):
                print(error)
            default: break
            }
        }.disposed(by: disposeBag)
        
        api.getFrames().flatMap{ frames -> Observable<Data> in
            return self.api.getImageData(url: frames[0].url)
        }.observeOn(MainScheduler.instance)
        .subscribe{ event in
            switch event {
            case .next(let imageData):
                self.imageView.image = UIImage(data: imageData)
            case .error(let error):
                print(error)
            default: break
            }
        }.disposed(by: disposeBag)
    }
}
