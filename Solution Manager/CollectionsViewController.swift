//
// CollectionsViewController.swift
// Ferrero-SolMan
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 15/10/18
//

import Foundation
import SAPFiori
import SAPOData

protocol EntityUpdaterDelegate {
    func entityHasChanged(_ entity: EntityValue?)
}

protocol EntitySetUpdaterDelegate {
    func entitySetHasChanged()
}

