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

    @IBOutlet private var webView: WKWebView!
    
    private let disposeBag = DisposeBag()
    private let apiManager = ApiManager()
    
    override func viewDidLoad() {
        /*apiManager.processData{ data, response in
            if let mimeType = response.mimeType, mimeType == "text/html",
                let string = String(data: data, encoding: .ascii) {
                self.webView.loadHTMLString(string, baseURL: nil)
            }
        }*/
    }
}
