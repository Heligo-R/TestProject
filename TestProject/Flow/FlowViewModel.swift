//
//  FlowViewModel.swift
//  TestProject
//
//  Created by Oleg on 17.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import Foundation
import RxSwift

final class FlowViewModel {
    var expandedCellRow: Int?
    var news: [News]?
    
    func retrieveData() -> Observable<[News]> {
        let observable: Observable<Newsletter> = NewsDataManagerMock().proceedResponse()
        return observable.map{ result in
            result.news
        }
    }
}


