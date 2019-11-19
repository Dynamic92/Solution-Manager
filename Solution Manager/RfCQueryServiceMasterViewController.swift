//
// RfCQueryServiceMasterViewController.swift
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
import SAPFioriFlows

class RfCQueryServiceMasterViewController: FUIFormTableViewController, SAPFioriLoadingIndicator, SAPURLSessionDelegate {
    private var zrequestforchangesrvEntities: ZREQUESTFORCHANGESRVEntities<OfflineODataProvider> {
        return self.appDelegate.zrequestforchangesrvEntities
    }
    public var loadEntitiesBlock: ((_ completionHandler: @escaping ([RfCQueryService]?, Error?) -> Void) -> Void)?
    public var loadEntitiesBlockRejected: ((_ completionHandler: @escaping ([RfCQueryService]?, Error?) -> Void) -> Void)?
    public var loadEntitiesBlockApproved: ((_ completionHandler: @escaping ([RfCQueryService]?, Error?) -> Void) -> Void)?
    static let shared = RfCQueryServiceMasterViewController()
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var rfcToBeApproved: [RfCQueryService] = [RfCQueryService]()
    var rfcRejected: [RfCQueryService] = [RfCQueryService]()
    var rfcApproved: [RfCQueryService] = [RfCQueryService]()
    private let logger = Logger.shared(named: "RfCQueryServiceMasterViewControllerLogger")
    private let okTitle = NSLocalizedString("keyOkButtonTitle",
                                            value: "OK",
                                            comment: "XBUT: Title of OK button.")
    var loadingIndicator: FUILoadingIndicatorView?
    var preventNavigationLoop = false
    var entitySetName: String?
    var kpiExampleData = [FUIKPIContainer]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadEntitiesBlock = fetchRfCQueryServiceSet
        self.loadEntitiesBlockRejected = fetchRfCQueryServiceSetRejected
        self.loadEntitiesBlockApproved = fetchRfCQueryServiceSetApproved
        self.setTabBarItem()
        self.setRefreshControl()
        self.setTableLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "load"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clearsSelectionOnViewWillAppear = false
        self.navigationController?.navigationBar.topItem?.title="Request for Change"
        self.tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.items?[1].badgeValue = String(self.rfcApproved.count + self.rfcRejected.count)
        self.refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func hamburgerBtnAction(_ sender: UIBarButtonItem) {
        HamburgerMenu().triggerSideMenu()
    }
    
    @objc func hideHamburger(){
        HamburgerMenu().closeSideMenu()
    }
    
    // MARK: - Table view data source
    private func setKPIHeader() {
        let kpiHeader = FUIKPIHeader()
        var kpiItems = [FUIKPIContainer]()
        for index in 0...2 {
            kpiItems.append(kpiExampleData[index])
        }
        kpiHeader.items = kpiItems
        tableView.tableHeaderView = kpiHeader
    }
    
    private func initExampleData() {
        let image1 = UIImage(named:"Initial")
        let image2 = UIImage(named:"rejected")
        let image3 = UIImage(named:"Proposed")
        let kpiView1 = buildKPIView(items: [FUIKPIIconItem(icon: image1!.tinted(with: UIColor.preferredFioriColor(forStyle: .primary6))!),FUIKPIMetricItem(string: String(self.rfcToBeApproved.count))],
                                    captionLabelText: "Pending",
                                    colorScheme: .dark,
                                    isEnabled: true)
        
        let kpiView2 = buildKPIView(items: [FUIKPIIconItem(icon: image2!.tinted(with: UIColor.preferredFioriColor(forStyle: .primary6))!), FUIKPIMetricItem(string: String(self.rfcRejected.count))],
                                    captionLabelText: "Rejected",
                                    colorScheme: .dark,
                                    isEnabled: true)
        
        let kpiView3 = buildKPIView(items: [FUIKPIIconItem(icon: image3!.tinted(with: UIColor.preferredFioriColor(forStyle: .primary6))!), FUIKPIMetricItem(string: String(self.rfcApproved.count))],
                                    captionLabelText: "Approved",
                                    colorScheme: .dark,
                                    isEnabled: true)
        kpiExampleData = [kpiView1, kpiView2, kpiView3]
        UserDefaults.standard.set(self.rfcApproved.count, forKey: "approvedcount")
        UserDefaults.standard.set(self.rfcRejected.count, forKey: "rejectedcount")
        UserDefaults.standard.set(self.rfcToBeApproved.count, forKey: "tobeapprovedcount")
        UIApplication.shared.applicationIconBadgeNumber = self.rfcToBeApproved.count
        UserDefaults.standard.synchronize()
        tabBarController?.tabBar.items?[0].badgeValue = String(self.rfcToBeApproved.count)
        if (self.rfcToBeApproved.count == 0) {
            tabBarController?.tabBar.items?[1].badgeValue = String(self.rfcApproved.count + self.rfcRejected.count)
        }
    }
    
    
    private func buildKPIView(items: [FUIKPIViewItem], captionLabelText: String = "", captionLabelLines: Int = 0, colorScheme: FUIBackgroundColorScheme = .light, isEnabled: Bool = true) -> FUIKPIView {
        let kpiView = FUIKPIView()
        kpiView.items = items
        kpiView.captionlabel.text = captionLabelText
        kpiView.captionlabel.numberOfLines = 1
        kpiView.tintColor = UIColor.preferredFioriColor(forStyle: .primary6)
        kpiView.captionlabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        kpiView.isEnabled = isEnabled
        kpiView.frame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude)
        return kpiView
    }
    
    func setTabBarItem(){
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(RfCQueryServiceMasterViewController.shared.hamburgerBtnAction)
    }
    
    func setTableLayout(){
        self.tableView.backgroundColor = UIColor.preferredFioriColor(forStyle: .backgroundBase)
        self.tableView.separatorStyle = .none
        self.edgesForExtendedLayout = []
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 44
        self.tableView.estimatedSectionHeaderHeight = 44
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.navigationController?.navigationBar.shadowImage = UIImage()
        tableView.register(FUITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)
    }
    
    func setRefreshControl(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.updateData), for: UIControlEvents.valueChanged)
        self.refreshControl?.tintColor = UIColor.preferredFioriColor(forStyle: .primary6)
        self.tableView.addSubview(refreshControl!)
    }
    
    
    func cancelLocalChanges(){
        DispatchQueue.global().async {
            for entity in self.rfcApproved{
                do{
                    try self.appDelegate.zrequestforchangesrvEntities.undoPendingChanges(for: entity)
                }
                catch{
                    print(error)
                }
            }
            for entity in self.rfcRejected{
                do{
                    try self.appDelegate.zrequestforchangesrvEntities.undoPendingChanges(for: entity)
                }
                catch{
                    print(error)
                }
            }
        }
    }
    
    @objc func updateData() {
        if (ConnectivityUtils.isConnected()){
            self.cancelLocalChanges()
            self.appDelegate.openOfflineStore(onboarding: false, isBackground: true)
        }
        else{
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        if (self.rfcToBeApproved.count == 0)
        {
            noDataLabel.text          = "No Rfc assigned to " + (UserDefaults.standard.string(forKey: "USER") ?? "")
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }
        noDataLabel.text = ""
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        tableView.backgroundView = noDataLabel
        return 1
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        UIApplication.shared.applicationIconBadgeNumber = self.rfcToBeApproved.count
        UserDefaults.standard.synchronize()
        self.rfcToBeApproved.sort(by: {x, y -> Bool in
            x.objectID! > y.objectID!
        })
        return self.rfcToBeApproved.count
    }
    
    override func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tabBarController?.tabBar.items?[1].badgeValue = String(self.rfcApproved.count + self.rfcRejected.count)
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath) as! FUIObjectTableViewCell
        let rfcqueryservice = self.rfcToBeApproved[indexPath.row]
        //let today = Calendar.current.date(byAdding: .day, value: -4, to: Date())
        //let createdAt = serverToLocal(date: String(describing: rfcqueryservice.createdAt!))
        cell.headlineText = rfcqueryservice.description
        cell.subheadlineText = "Requester: " + rfcqueryservice.createdBy!
        cell.footnoteText = "Object ID: " + rfcqueryservice.objectID!
        /*if (today! < createdAt!){
         cell.statusImage = UIImage(named: "new")
         cell.substatusText = "Pending"
         }
         else{*/
        cell.statusText = "Pending"
        //}
        cell.substatusLabel.textColor = UIColor.preferredFioriColor(forStyle: .critical)
        cell.statusLabel.textColor = UIColor.preferredFioriColor(forStyle: .critical)
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.rfcToBeApproved.count==0){
            return
        }
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let detailViewController = mainStoryBoard.instantiateViewController(withIdentifier: "RfCQueryServiceDetailViewController") as! RfCQueryServiceDetailViewController
        let selectedEntity = self.rfcToBeApproved[indexPath.row]
        let serviceSet = ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCQueryServiceSet
        let query = DataQuery().from(serviceSet).withKey(RfCQueryService.key(objectID: selectedEntity.objectID!, processType: selectedEntity.processType!))
        detailViewController.query = query
        detailViewController.allowsEditableCells = false
        detailViewController.navigationItem.leftItemsSupplementBackButton = true
        detailViewController.entitySetName = self.entitySetName
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.show(detailViewController, sender: nil)
    }
    
    func fetchRfCQueryServiceSet(_ completionHandler: @escaping ([RfCQueryService]?, Error?) -> Void) {
        let status = RfCQueryService.status
        let queryLimit = DataQuery().selectAll().where(status.equal("E0012"))
        do {
            self.appDelegate.zrequestforchangesrvEntities!.fetchRfCQueryServiceSet(matching: queryLimit) { rfCQueryServiceSet, error in
                if error == nil {
                    completionHandler(rfCQueryServiceSet, nil)
                } else {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    func fetchRfCQueryServiceSetRejected(_ completionHandler: @escaping ([RfCQueryService]?, Error?) -> Void) {
        let status = RfCQueryService.status
        let queryLimit = DataQuery().selectAll().where(status.equal("E0003"))
        do {
            self.appDelegate.zrequestforchangesrvEntities!.fetchRfCQueryServiceSet(matching: queryLimit) { rfCQueryServiceSet, error in
                if error == nil {
                    completionHandler(rfCQueryServiceSet, nil)
                } else {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    func fetchRfCQueryServiceSetApproved(_ completionHandler: @escaping ([RfCQueryService]?, Error?) -> Void) {
        let status = RfCQueryService.status
        let queryLimit = DataQuery().selectAll().where(status.equal("E0004"))
        do {
            self.appDelegate.zrequestforchangesrvEntities!.fetchRfCQueryServiceSet(matching: queryLimit) { rfCQueryServiceSet, error in
                if error == nil {
                    completionHandler(rfCQueryServiceSet, nil)
                } else {
                    completionHandler(nil, error)
                }
            }
        }
    }
    // MARK: - Data accessing
    
    func requestEntities(completionHandler: @escaping (Error?) -> Void) {
        print("requestEntities")
        self.loadEntitiesBlock!() { entities, error in
            if let error = error {
                completionHandler(error)
                return
            }
            self.rfcToBeApproved = entities!
            completionHandler(nil)
        }
        
        self.loadEntitiesBlockRejected!() { entities, error in
            if let error = error {
                completionHandler(error)
                return
            }
            self.rfcRejected = entities!
            completionHandler(nil)
        }
        
        self.loadEntitiesBlockApproved!() { entities, error in
            if let error = error {
                completionHandler(error)
                return
            }
            self.rfcApproved = entities!
            completionHandler(nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FUITableViewHeaderFooterView.reuseIdentifier) as! FUITableViewHeaderFooterView
        view.backgroundView = UIView()
        view.backgroundView?.backgroundColor = UIColor.preferredFioriColor(forStyle: .primary6)
        view.layer.borderWidth = 0.5
        view.isUserInteractionEnabled = false
        view.titleLabel.text = "To be Approved - " + (UserDefaults.standard.string(forKey: "USER") ?? "")
        return view
    }
    
    
    // MARK: - Table update
    
    func updateTable() {
        print("updateTable")
        self.showFioriLoadingIndicator()
        let oq = OperationQueue()
        oq.addOperation({
            self.loadData {
                self.hideFioriLoadingIndicator()
            }
        })
    }
    
    func serverToLocal(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let localDate = dateFormatter.date(from: date)
        return localDate
    }
    
    private func loadData(completionHandler: @escaping () -> Void) {
        print("loadData")
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
                self.tableView.reloadData()
                self.initExampleData()
                self.setKPIHeader()
                self.logger.info("Table updated successfully!")
            })
        }
    }
    
    @objc func refresh() {
        print("refresh")
        
        let oq = OperationQueue()
        oq.addOperation({
            self.loadData {
                OperationQueue.main.addOperation({
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load2"), object: nil)
                    self.refreshControl?.endRefreshing()
                })
            }
        })
    }
    
}

extension RfCQueryServiceMasterViewController: EntitySetUpdaterDelegate {
    func entitySetHasChanged() {
        self.updateTable()
    }
}

extension UIImage {
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
