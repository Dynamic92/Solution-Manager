//
// RfCQueryServiceDetailViewController.swift
// Approve-RfC
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 24/07/18
//

import Foundation
import SAPCommon
import SAPFiori
import SAPFoundation
import SAPOData
import SAPOfflineOData
import Photos

class RfCQueryServiceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SAPFioriLoadingIndicator {
    
    @IBOutlet weak var approveButton: UIButton!
    
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    var rowsNumberSection0 = 5
    var rowsNumberSection1 = 5
    var rowsNumberSection2 = 0
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var zrequestforchangesrvEntities: ZREQUESTFORCHANGESRVEntities<OfflineODataProvider> {
        return self.appDelegate.zrequestforchangesrvEntities
    }
    private var zrequestforchangesrvEntitiesOnline: ZREQUESTFORCHANGESRVEntities<OnlineODataProvider> {
        return self.appDelegate.zrequestforchangesrvEntitiesOnline
    }
    public var loadEntitiesBlock: ((_ completionHandler: @escaping (RfCQueryService?, Error?) -> Void) -> Void)?
    var query : DataQuery?
    private var validity = [String: Bool]()
    private var _entity: RfCQueryService?
    var allowsEditableCells = false
    var entity: RfCQueryService {
        get {
            if self._entity == nil {
                self._entity = self.createEntityWithDefaultValues()
            }
            return self._entity!
        }
        set {
            self._entity = newValue
        }
    }
    
    private let logger = Logger.shared(named: "RfCQueryServiceMasterViewControllerLogger")
    let objectHeader = FUIObjectHeader(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
    var loadingIndicator: FUILoadingIndicatorView?
    var entityUpdater: EntityUpdaterDelegate?
    var tableUpdater: EntitySetUpdaterDelegate?
    private let okTitle = NSLocalizedString("keyOkButtonTitle",
                                            value: "OK",
                                            comment: "XBUT: Title of OK button.")
    var preventNavigationLoop = false
    var entitySetName: String?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.register(FUITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)
        myTableView.tableHeaderView = self.objectHeader
        myTableView.separatorStyle = .none
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.estimatedRowHeight = 44
        self.loadEntitiesBlock = fetchRfCQueryServiceSet
        self.setApproveRejectButton()
        self.updateTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setApproveRejectButton(){
        approveButton.backgroundColor = UIColor.preferredFioriColor(forStyle: .positive)
        approveButton.setTitle("Approve", for: .normal)
        //approveButton.titleLabel?.preferredMaxLayoutWidth = 200
        //approveButton.isPreservingPreferredMaxLayoutWidth = true
       approveButton.titleLabel?.textColor = UIColor.preferredFioriColor(forStyle: .primary6)

        approveButton.setTitleColor(UIColor.preferredFioriColor(forStyle: .primary6), for: .normal)
        approveButton.addTarget(self, action: #selector(self.approveRFC), for: .touchUpInside)
        rejectButton.backgroundColor = UIColor.preferredFioriColor(forStyle: .negative)
        rejectButton.setTitleColor(UIColor.preferredFioriColor(forStyle: .primary6), for: .normal)
        rejectButton.titleLabel?.preferredMaxLayoutWidth = 200
        rejectButton.setTitle("Reject", for: .normal)
        rejectButton.addTarget(self, action: #selector(self.rejectRFC), for: .touchUpInside)
    }

    func executeQuery(_ queryInput: DataQuery, _ message: String, _ queryString: [String]){
        DispatchQueue.global().async {
            do{
                if (ConnectivityUtils.isConnected()){
                    try
                    self.appDelegate.zrequestforchangesrvEntitiesOnline.fetchRfCApprove(matching: queryInput)
                } else{
                    var queryArray = self.defaults.object(forKey: "QueryInputArray") as? [[String]]
                    if (queryArray != nil){
                        queryArray?.append(queryString)
                    } else{
                        queryArray = [[String]]()
                        queryArray?.append(queryString)
                    }
                    self.defaults.set(queryArray, forKey: "QueryInputArray")
                    self.defaults.synchronize()
                }
            }
            catch{
                print(error)
                return
            }
        }
        
        do{
            if (message.contains("RFC has been approved.")){
                    self.entity.status = "E0004"
                }
                
            else{
                self.entity.status = "E0003"
            }
            
            try self.appDelegate.zrequestforchangesrvEntities.updateEntity(self.entity)
            //try self.appDelegate.zrequestforchangesrvEntities.deleteEntity(self.entity)
            self.showToast(message)
        }
        catch{
            print(error)
        }
    }
    
    func showToast(_ message: String){
        FUIToastMessage.show(message: NSLocalizedString("keyUpdateEntityFinishedTitle", value: message, comment: "XTIT: Title of alert message about successful action performed."))
    }
    
    
    func fetchRfCQueryServiceSet(_ completionHandler: @escaping (RfCQueryService?, Error?) -> Void) {
        
        do {
            self.appDelegate.zrequestforchangesrvEntities!.fetchRfCQueryService(matching: self.query!) { rfCQueryServiceSet, error in
                if error == nil {
                    completionHandler(rfCQueryServiceSet, nil)
                } else {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    private func loadData(completionHandler: @escaping () -> Void) {
        self.requestEntities { error in
            defer {
                completionHandler()
            }
            if let error = error {
                let alertController = UIAlertController(title: NSLocalizedString("keyErrorLoadingData", value: "Loading data failed!", comment: "XTIT: Title of loading data error pop up."), message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: self.okTitle, style: .default))
                OperationQueue.main.addOperation({
                    // Present the alertController
                    self.present(alertController, animated: true)
                })
                self.logger.error("Could not update table. Error: \(error)", error: error)
                return
            }
            OperationQueue.main.addOperation({
                self.myTableView.reloadData()
                self.logger.info("Table updated successfully!")
            })
        }
    }
    
    func updateTable() {
        self.showFioriLoadingIndicator()
        let oq = OperationQueue()
        oq.addOperation({
            self.loadData {
                self.hideFioriLoadingIndicator()
            }
        })
    }
    
    func requestEntities(completionHandler: @escaping (Error?) -> Void) {
        self.loadEntitiesBlock!() { entities, error in
            if let error = error {
                completionHandler(error)
                return
            }
            self.entity = entities!
            completionHandler(nil)
        }
    }
    
    // MARK: - Table view data source
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section==0) {
            switch indexPath.row {
            case 0:
                return self.cellForObjectID(tableView: myTableView, indexPath: indexPath, currentEntity: self.entity, property: RfCQueryService.objectID)
            case 1:
                return self.cellForDescription(tableView: myTableView, indexPath: indexPath, currentEntity: self.entity, property: RfCQueryService.description)
            case 2:
                return self.cellForSoldToParty(tableView: myTableView, indexPath: indexPath, currentEntity: self.entity, property: RfCQueryService.soldToParty)
            case 3:
                return self.cellForRequester(tableView: myTableView, indexPath: indexPath, currentEntity: self.entity, property: RfCQueryService.requester)
            case 4:
                return self.cellForStatus(tableView: myTableView, indexPath: indexPath, currentEntity: self.entity, property: RfCQueryService.status)
            default:
                return UITableViewCell()
            }
        }
        if (indexPath.section==1) {
            switch indexPath.row {
            case 0:
                self.setRequestForChange(self.entity)
                return self.cellForLandscape(tableView: myTableView, indexPath: indexPath, currentEntity: self.entity, property: RfCQueryService.landscape)
            case 1:
                return self.cellForProcessType(tableView: myTableView, indexPath: indexPath, currentEntity: self.entity, property: RfCQueryService.processType)
            case 2:
                return self.cellForChangeCycle(tableView: myTableView, indexPath: indexPath, currentEntity: self.entity, property: RfCQueryService.changeCycle)
            case 3:
                return self.cellForCorrection(tableView: myTableView, indexPath: indexPath, currentEntity: self.entity, property: RfCQueryService.correction)
            case 4:
                return self.cellForTicket(tableView: myTableView, indexPath: indexPath, currentEntity: self.entity, property: RfCQueryService.ticket)
            default:
                return UITableViewCell()
            }
        }
        else {
            switch indexPath.row {
            case 0:
                return self.cellForCreatedAt(tableView: myTableView, indexPath: indexPath, currentEntity: self.entity, property: RfCQueryService.createdAt)
                
            case 1:
                return self.cellForRequestedStart(tableView: myTableView, indexPath: indexPath, currentEntity: self.entity, property: RfCQueryService.requestedStart)
            case 2:
                return self.cellForRequestedEnd(tableView: myTableView, indexPath: indexPath, currentEntity: self.entity, property: RfCQueryService.requestedEnd)
            case 3:
                return self.cellForDueBy(tableView: myTableView, indexPath: indexPath, currentEntity: self.entity, property: RfCQueryService.dueBy)
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if (section == 2){
            return 0
        }
        return 20
    }
    
     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let myView = UIView()
        return myView
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
     func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.entity.changeManager!.isEmpty){
            return 0
        }
        switch (section) {
        case 0:
            return rowsNumberSection0
        case 1:
            return rowsNumberSection1
        case 2:
            return rowsNumberSection2
        default:
            return 0
        }
    }
    
     func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.preventNavigationLoop {
            return
        }
        switch indexPath.row {
        default:
            return
        }
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (self.entity.changeManager!.isEmpty){
            return UIView()
        }
        let expandableButton = UIButton()
        expandableButton.contentHorizontalAlignment = .left
        expandableButton.backgroundColor = UIColor.white
        expandableButton.setTitleColor(.black, for: .normal)
        expandableButton.addTarget(self, action: #selector(handleExpandeClose), for: .touchUpInside)
        expandableButton.tag = section
        if (section == 0){
            expandableButton.setTitle("   General Data (5)  ▲", for: .normal)
            return expandableButton
        }
        if (section == 1) {
            expandableButton.setTitle("   Ferrero Request (5)  ▲", for: .normal)
            return expandableButton
        }
        if (section == 2) {
            expandableButton.setTitle("   Dates (4)  ▼", for: .normal)
            return expandableButton
        }
        let myView = UIView()
        return myView
    }
    
    @objc func handleExpandeClose(button: UIButton){
        
        if (button.tag==0){
            var indexPaths = [IndexPath]()
            for x in 0..<5 {
                let indexPath = IndexPath(row: x, section: button.tag)
                indexPaths.append(indexPath)
            }
            if (rowsNumberSection0 == 5){
                rowsNumberSection0 = 0
                button.setTitle("   General Data (5)  ▼", for: .normal)
                myTableView.beginUpdates()
                myTableView.deleteRows(at: indexPaths, with: .fade)
                myTableView.endUpdates()
            }
            else {
                rowsNumberSection0 = 5
                button.setTitle("   General Data (5)  ▲", for: .normal)
                myTableView.beginUpdates()
                myTableView.insertRows(at: indexPaths, with: .fade)
                myTableView.endUpdates()
            }
        }
        if (button.tag==1){
            var indexPaths = [IndexPath]()
            for x in 0..<5 {
                let indexPath = IndexPath(row: x, section: button.tag)
                indexPaths.append(indexPath)
            }
            if (rowsNumberSection1 == 5){
                rowsNumberSection1 = 0
                button.setTitle("   Ferrero Request (5)  ▼", for: .normal)
                myTableView.beginUpdates()
                myTableView.deleteRows(at: indexPaths, with: .fade)
                myTableView.endUpdates()
            }
            else {
                rowsNumberSection1 = 5
                button.setTitle("   Ferrero Request (5)  ▲", for: .normal)
                myTableView.beginUpdates()
                myTableView.insertRows(at: indexPaths, with: .fade)
                myTableView.endUpdates()
                self.scrollToBottom(indexPath: IndexPath(row: 2, section: 1), at: .middle)
            }
        }
        if (button.tag==2){
            var indexPaths = [IndexPath]()
            for x in 0..<4 {
                let indexPath = IndexPath(row: x, section: 2)
                indexPaths.append(indexPath)
            }
            if (rowsNumberSection2 == 4){
                myTableView.beginUpdates()
                rowsNumberSection2 = 0
                button.setTitle("   Dates (4)  ▼", for: .normal)
                myTableView.deleteRows(at: indexPaths, with: .fade)
                myTableView.endUpdates()
            }
            else {
                myTableView.beginUpdates()
                rowsNumberSection2 = 4
                button.setTitle("   Dates (4)  ▲", for: .normal)
                myTableView.insertRows(at: indexPaths, with: .fade)
                myTableView.endUpdates()
                self.scrollToBottom(indexPath: IndexPath(row: 3, section: 2), at: .bottom)
            }
        }
    }
    
    func scrollToBottom(indexPath: IndexPath, at: UITableView.ScrollPosition){
        DispatchQueue.main.async {
            self.myTableView.scrollToRow(at: indexPath, at: at, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func setRequestForChange(_ requestForChange: RfCQueryService) {
        
        self.entity = requestForChange
        self.objectHeader.headlineText = requestForChange.description
        self.objectHeader.subheadlineText = "Created by: " + requestForChange.createdBy!
        self.objectHeader.tags = ["To be Approved"].map({
            FUITag(title: $0)
        })
        self.objectHeader.bodyText = "Object ID: " + requestForChange.objectID!
        self.objectHeader.footnoteText = "Created at: " + (requestForChange.createdAt?.date.toString())! + ", " + (requestForChange.createdAt?.time.toString())!
    }
    
    
    /*func createStackView(with layout: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        stackView.axis = layout
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        return stackView
    }
    */
    @objc func approveRFC() {
        let approveSet = ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCApproveSet
        let keyApprove = RfCApprove.key(objectID: self.entity.objectID!, processType: self.entity.processType!, operationType: "A")
        let queryApprove = DataQuery().from(approveSet).withKey(keyApprove)
        let queryString = [self.entity.objectID, self.entity.processType, "A"] as! [String]
            let alertController = UIAlertController(
                title: "Confirm Approval",
                message: "You cannot undo this step after approval.",
                preferredStyle: UIAlertController.Style.alert
            )
            let confirmAction = UIAlertAction(
            title: "Approve", style: UIAlertAction.Style.default) { (action) in
                    print(queryApprove)
                self.executeQuery(queryApprove, "RFC has been approved.", queryString)
                    self.navigationController?.popViewController(animated: true)
            }
            let cancelAction = UIAlertAction(
            title: "Cancel", style: UIAlertAction.Style.default) { (action) in
                return
            }
            
        confirmAction.setValue(UIColor.preferredFioriColor(forStyle: .positive), forKey: "titleTextColor")
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func rejectRFC() {
         let approveSet = ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCApproveSet
        let keyReject = RfCApprove.key(objectID: self.entity.objectID!, processType: self.entity.processType!, operationType: "R")
        let queryReject = DataQuery().from(approveSet).withKey(keyReject)
        let queryString = [self.entity.objectID, self.entity.processType, "R"] as! [String]
            let alertController = UIAlertController(
                title: "Confirm Reject",
                message: "You cannot undo this step after rejection.",
                preferredStyle: UIAlertController.Style.alert
            )
            let rejectAction = UIAlertAction(
            title: "Reject", style: UIAlertAction.Style.destructive) { (action) in
                self.executeQuery(queryReject, "RFC has been rejected.", queryString)
                self.navigationController?.popViewController(animated: true)
            }
            let cancelAction = UIAlertAction(
            title: "Cancel", style: UIAlertAction.Style.default) { (action) in
                return
            }
            alertController.addAction(cancelAction)
            alertController.addAction(rejectAction)
            self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - OData property specific cell creators
    
    private func cellForObjectID(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.objectID ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.objectID.isOptional || newValue != "" {
                currentEntity.objectID = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForProcessType(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.processType ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.processType.isOptional || newValue != "" {
                currentEntity.processType = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForStatus(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        let value = "To be Approved"
        //value = "\(currentEntity.status ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.status.isOptional || newValue != "" {
                currentEntity.status = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    
    private func cellForTicket(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.ticket ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.ticket.isOptional || newValue != "" {
                currentEntity.ticket = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForDescription(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.description ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.description.isOptional || newValue != "" {
                currentEntity.description = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForCreatedAt(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = currentEntity.createdAt != nil ? "\((currentEntity.createdAt?.date.toString())! + ", " + (currentEntity.createdAt?.time.toString())!)" : ""
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if let validValue = LocalDateTime.parse(newValue) { // This is just a simple solution to handle UTC only
                currentEntity.createdAt = validValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForCreatedBy(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.createdBy ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.createdBy.isOptional || newValue != "" {
                currentEntity.createdBy = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForChangeManager(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.changeManager ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.changeManager.isOptional || newValue != "" {
                currentEntity.changeManager = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForLandscape(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.landscape ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.landscape.isOptional || newValue != "" {
                currentEntity.landscape = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForCorrection(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.correction ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.correction.isOptional || newValue != "" {
                currentEntity.correction = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForSystem(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.system ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.system.isOptional || newValue != "" {
                currentEntity.system = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForSoldToParty(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.soldToParty ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.soldToParty.isOptional || newValue != "" {
                currentEntity.soldToParty = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForRequester(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.requester ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.requester.isOptional || newValue != "" {
                currentEntity.requester = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForRequestedStart(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        if currentEntity.requestedStart != nil {
            value = "\((currentEntity.requestedStart?.date.toString())! + ", " + (currentEntity.requestedStart?.time.toString())!)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.requestedStart = nil
                isNewValueValid = true
            } else {
                if let validValue = LocalDateTime.parse(newValue) { // This is just a simple solution to handle UTC only
                    currentEntity.requestedStart = validValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForRequestedEnd(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        if currentEntity.requestedEnd != nil {
            value = "\((currentEntity.requestedEnd?.date.toString())! + ", " + (currentEntity.requestedEnd?.time.toString())!)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.requestedEnd = nil
                isNewValueValid = true
            } else {
                if let validValue = LocalDateTime.parse(newValue) { // This is just a simple solution to handle UTC only
                    currentEntity.requestedEnd = validValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForDueBy(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        if currentEntity.dueBy != nil {
            value = "\((currentEntity.dueBy?.date.toString())! + ", " + (currentEntity.dueBy?.time.toString())!)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.dueBy = nil
                isNewValueValid = true
            } else {
                if let validValue = LocalDateTime.parse(newValue) { // This is just a simple solution to handle UTC only
                    currentEntity.dueBy = validValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForChangeCycle(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.changeCycle ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.changeCycle.isOptional || newValue != "" {
                currentEntity.changeCycle = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForPhase(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.phase ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.phase.isOptional || newValue != "" {
                currentEntity.phase = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForType_(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.type_ ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.type_.isOptional || newValue != "" {
                currentEntity.type_ = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForId(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.id ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.id.isOptional || newValue != "" {
                currentEntity.id = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForLandscapeCycle(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.landscapeCycle ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.landscapeCycle.isOptional || newValue != "" {
                currentEntity.landscapeCycle = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForBranch(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.branch ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.branch.isOptional || newValue != "" {
                currentEntity.branch = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForDevelopmentClose(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.developmentClose {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.developmentClose = nil
                isNewValueValid = true
            } else {
                if let validValue = LocalDateTime.parse(newValue) { // This is just a simple solution to handle UTC only
                    currentEntity.developmentClose = validValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForGoLiveDate(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.goLiveDate {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            // The property is optional, so nil value can be accepted
            if newValue.isEmpty {
                currentEntity.goLiveDate = nil
                isNewValueValid = true
            } else {
                if let validValue = LocalDateTime.parse(newValue) { // This is just a simple solution to handle UTC only
                    currentEntity.goLiveDate = validValue
                    isNewValueValid = true
                }
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    private func cellForLongDescription(tableView: UITableView, indexPath: IndexPath, currentEntity: RfCQueryService, property: Property) -> UITableViewCell {
        var value = ""
        value = "\(currentEntity.longDescription ?? "")"
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: self.entity, property: property, value: value, editingIsAllowed: self.allowsEditableCells, changeHandler: { (newValue: String) -> Bool in
            var isNewValueValid = false
            if RfCQueryService.longDescription.isOptional || newValue != "" {
                currentEntity.longDescription = newValue
                isNewValueValid = true
            }
            self.validity[property.name] = isNewValueValid
            self.barButtonShouldBeEnabled()
            return isNewValueValid
        })
    }
    
    // MARK: - OData functionalities
    
    @objc func createEntity() {
        self.showFioriLoadingIndicator()
        self.view.endEditing(true)
        self.logger.info("Creating entity in backend.")
        self.zrequestforchangesrvEntities.createEntity(self.entity) { error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Create entry failed. Error: \(error)", error: error)
                let alertController = UIAlertController(title: NSLocalizedString("keyErrorEntityCreationTitle", value: "Create entry failed", comment: "XTIT: Title of alert message about entity creation error."), message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: self.okTitle, style: .default))
                OperationQueue.main.addOperation({
                    // Present the alertController
                    self.present(alertController, animated: true)
                })
                return
            }
            self.logger.info("Create entry finished successfully.")
            OperationQueue.main.addOperation({
                self.dismiss(animated: true) {
                    FUIToastMessage.show(message: NSLocalizedString("keyEntityCreationBody", value: "Created", comment: "XMSG: Title of alert message about successful entity creation."))
                    self.tableUpdater?.entitySetHasChanged()
                }
            })
        }
    }
    
    func createEntityWithDefaultValues() -> RfCQueryService {
        let newEntity = RfCQueryService()
        // Fill the mandatory properties with default values
        newEntity.objectID = CellCreationHelper.defaultValueFor(RfCQueryService.objectID)
        newEntity.processType = CellCreationHelper.defaultValueFor(RfCQueryService.processType)
        newEntity.ticket = CellCreationHelper.defaultValueFor(RfCQueryService.ticket)
        newEntity.description = CellCreationHelper.defaultValueFor(RfCQueryService.description)
        newEntity.createdAt = CellCreationHelper.defaultValueFor(RfCQueryService.createdAt)
        newEntity.createdBy = CellCreationHelper.defaultValueFor(RfCQueryService.createdBy)
        newEntity.changeManager = CellCreationHelper.defaultValueFor(RfCQueryService.changeManager)
        newEntity.landscape = CellCreationHelper.defaultValueFor(RfCQueryService.landscape)
        newEntity.correction = CellCreationHelper.defaultValueFor(RfCQueryService.correction)
        newEntity.system = CellCreationHelper.defaultValueFor(RfCQueryService.system)
        newEntity.soldToParty = CellCreationHelper.defaultValueFor(RfCQueryService.soldToParty)
        newEntity.requester = CellCreationHelper.defaultValueFor(RfCQueryService.requester)
        newEntity.changeCycle = CellCreationHelper.defaultValueFor(RfCQueryService.changeCycle)
        newEntity.phase = CellCreationHelper.defaultValueFor(RfCQueryService.phase)
        newEntity.type_ = CellCreationHelper.defaultValueFor(RfCQueryService.type_)
        newEntity.id = CellCreationHelper.defaultValueFor(RfCQueryService.id)
        newEntity.landscapeCycle = CellCreationHelper.defaultValueFor(RfCQueryService.landscapeCycle)
        newEntity.branch = CellCreationHelper.defaultValueFor(RfCQueryService.branch)
        newEntity.longDescription = CellCreationHelper.defaultValueFor(RfCQueryService.longDescription)
        
        // Key properties without default value should be invalid by default for Create scenario
        if newEntity.objectID == nil || newEntity.objectID!.isEmpty {
            self.validity["ObjectId"] = false
        }
        if newEntity.processType == nil || newEntity.processType!.isEmpty {
            self.validity["ProcessType"] = false
        }
        self.barButtonShouldBeEnabled()
        return newEntity
    }
    
    // MARK: - other logic, helper
    
    @objc func cancel() {
        OperationQueue.main.addOperation({
            self.dismiss(animated: true)
        })
    }
    
    // Check if all text fields are valid
    private func barButtonShouldBeEnabled() {
        let anyFieldInvalid = self.validity.values.first { field in
            return field == false
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = anyFieldInvalid == nil
    }
}

extension RfCQueryServiceDetailViewController: EntityUpdaterDelegate {
    func entityHasChanged(_ entityValue: EntityValue?) {
        if let entity = entityValue {
            let currentEntity = entity as! RfCQueryService
            self.entity = currentEntity
            DispatchQueue.main.async { [weak self] in
                self!.myTableView.reloadData()
            }
        }
    }
}
