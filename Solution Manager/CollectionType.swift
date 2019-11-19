//
// CollectionType.swift
// Solution Manager
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 07/05/19
//

import Foundation

enum CollectionType: String {
    case rfCQueryServiceSet = "RfCQueryServiceSet"
    case rfCApproveSet = "RfCApproveSet"
    case none = ""

    static let all = [
        rfCQueryServiceSet, rfCApproveSet,
    ]
}
