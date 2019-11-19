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

@available(iOS 11.0, *)
class RFCProcessedMasterViewController: FUIFormTableViewController, SAPFioriLoadingIndicator, UISearchBarDelegate {
    private var zrequestforchangesrvEntities: ZREQUESTFORCHANGESRVEntities<OfflineODataProvider> {
        return self.appDelegate.zrequestforchangesrvEntities
    }
    public var loadEntitiesBlock: ((_ completionHandler: @escaping ([RfCQueryService]?, Error?) -> Void) -> Void)?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    public var entities: [RfCQueryService] = [RfCQueryService]()
    public var currentEntities: [RfCQueryService] = [RfCQueryService]()
    private let logger = Logger.shared(named: "RfCQueryServiceMasterViewControllerLogger")
    private let okTitle = NSLocalizedString("keyOkButtonTitle",
                                            value: "OK",
                                            comment: "XBUT: Title of OK button.")
    var loadingIndicator: FUILoadingIndicatorView?
    var preventNavigationLoop = false
    var entitySetName: String?
    var kpiExampleData = [FUIKPIContainer]()
    static let shared = RFCProcessedMasterViewController()
    var searchBarButtonItem = UIBarButtonItem()
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshKPIHeader), name: NSNotification.Name(rawValue: "load2"), object: nil)
        self.loadEntitiesBlock = fetchRfCQueryServiceSet
        self.setRefreshControl()
        self.setTableLayout()
        self.setTabBarItem()
        self.updateTable()
        self.setSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            tabBarController?.tabBar.items?[0].badgeValue = String(UserDefaults.standard.integer(forKey: "tobeapprovedcount"))
        self.tabBarController?.tabBar.isHidden = false
        self.initExampleData()
        self.setKPIHeader()
        self.refresh()
    }
    
    @objc func refreshKPIHeader(){
        self.initExampleData()
        self.setKPIHeader()
        self.refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setKPIHeader() {
        let kpiHeader = FUIKPIHeader()
        var kpiItems = [FUIKPIContainer]()
        
        for index in 0...2 {
            kpiItems.append(kpiExampleData[index])
        }
        kpiHeader.items = kpiItems
        tableView.tableHeaderView = kpiHeader
    }
    
    private func setSearchBar() {
        searchBarButtonItem = UIBarButtonItem(image: FUIIconLibrary.system.search.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(showSearchBar))
        navigationItem.rightBarButtonItem = searchBarButtonItem
       }
    
     @objc func showSearchBar() {
        isSearchBarOpen = true
        self.searchController.isActive = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.alpha = 0
        searchController.searchBar.delegate = self
        self.searchController.searchBar.endEditing(true)
        definesPresentationContext = true
        navigationItem.setRightBarButton(nil, animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            let searchBarContainer = SearchBarContainerView(customSearchBar:  self.searchController.searchBar)
            searchBarContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
            self.navigationItem.titleView = searchBarContainer
          }, completion: { finished in
            self.searchController.searchBar.becomeFirstResponder()
        })
        
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentEntities = entities
        tableView.reloadData()
        self.closeSearchBar()
    }
    
    @objc func hideKeyboard() {
      searchController.searchBar.endEditing(true)
    }
    
    func closeSearchBar(){
        navigationItem.setRightBarButton(searchBarButtonItem, animated: true)
        self.searchController.searchBar.resignFirstResponder()
        isSearchBarOpen = false
        UIView.animate(withDuration: 0.4, animations: {
          self.navigationItem.titleView = nil
          }, completion: { finished in
            self.searchController.isActive = false
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            currentEntities = entities
            tableView.reloadData()
            return
        }
         currentEntities = self.entities.filter({ rfc -> Bool in
            guard let text = searchBar.text else {return false}
            return (rfc.objectID!.contains(text) || rfc.description!.lowercased().contains(text.lowercased()) || rfc.soldToParty!.lowercased().contains(text.lowercased()) || rfc.landscape!.lowercased().contains(text.lowercased()) || rfc.processType!.lowercased().contains(text.lowercased()) || rfc.correction!.lowercased().contains(text.lowercased()) || rfc.requester!.lowercased().contains(text.lowercased()))
        })
        tableView.reloadData()
    }
    
    
    private func initExampleData() {
        let image1 = UIImage(named:"Initial")
        let image2 = UIImage(named:"rejected")
        let image3 = UIImage(named:"Proposed")
        let kpiView1 = buildKPIView(items: [FUIKPIIconItem(icon: image1!.tinted(with: UIColor.preferredFioriColor(forStyle: .primary6))!),FUIKPIMetricItem(string: String(UserDefaults.standard.integer(forKey: "tobeapprovedcount")))],
                                    captionLabelText: "Pending",
                                    colorScheme: .dark,
                                    isEnabled: true)
        
        let kpiView2 = buildKPIView(items: [FUIKPIIconItem(icon: image2!.tinted(with: UIColor.preferredFioriColor(forStyle: .primary6))!), FUIKPIMetricItem(string: String(UserDefaults.standard.integer(forKey: "rejectedcount")))],
                                    captionLabelText: "Rejected",
                                    colorScheme: .dark,
                                    isEnabled: true)
        
        let kpiView3 = buildKPIView(items: [FUIKPIIconItem(icon: image3!.tinted(with: UIColor.preferredFioriColor(forStyle: .primary6))!), FUIKPIMetricItem(string: String(UserDefaults.standard.integer(forKey: "approvedcount")))],
                                    captionLabelText: "Approved",
                                    colorScheme: .dark,
                                    isEnabled: true)
        kpiExampleData = [kpiView1, kpiView2, kpiView3]
        if (self.entities.count==0) {
        tabBarController?.tabBar.items?[0].badgeValue = String(UserDefaults.standard.integer(forKey: "tobeapprovedcount"))
        }
        tabBarController?.tabBar.items?[1].badgeValue = String(UserDefaults.standard.integer(forKey: "approvedcount") + UserDefaults.standard.integer(forKey: "rejectedcount"))
    }
    
    @objc func hamburgerBtnAction(_ sender: UIBarButtonItem) {
        HamburgerMenu().triggerSideMenu()
      }
      
      @objc func hideHamburger(){
          HamburgerMenu().closeSideMenu()
      }
    
    
    private func buildKPIView(items: [FUIKPIViewItem], captionLabelText: String = "", captionLabelLines: Int = 0, colorScheme: FUIBackgroundColorScheme = .light, isEnabled: Bool = true) -> FUIKPIView {
        let kpiView = FUIKPIView()
        kpiView.items = items
        kpiView.captionlabel.text = captionLabelText
        kpiView.captionlabel.numberOfLines = 1
        //kpiView.colorScheme = colorScheme
        kpiView.tintColor = UIColor.preferredFioriColor(forStyle: .primary6)
        kpiView.captionlabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        kpiView.isEnabled = isEnabled
        kpiView.frame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude)
        return kpiView
    }
    
    // MARK: - Table view data source
    
    func setTableLayout(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.tableView.backgroundColor = UIColor.preferredFioriColor(forStyle: .backgroundBase)
        self.tableView.separatorStyle = .none
        self.edgesForExtendedLayout = []
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 44
        self.tableView.estimatedSectionHeaderHeight = 44
        tableView.addGestureRecognizer(tapGestureRecognizer)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.navigationController?.navigationBar.shadowImage = UIImage()
        tableView.register(FUITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: FUITableViewHeaderFooterView.reuseIdentifier)
    }
    
    func setTabBarItem(){
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(RFCProcessedMasterViewController.shared.hamburgerBtnAction)
    }
    
    func setRefreshControl(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.updateData), for: UIControlEvents.valueChanged)
        self.refreshControl?.tintColor = UIColor.preferredFioriColor(forStyle: .primary6)
        self.tableView.addSubview(refreshControl!)
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
  
    func cancelLocalChanges(){
        DispatchQueue.global().async {
        for entity in self.entities{
            do{
                try self.appDelegate.zrequestforchangesrvEntities.undoPendingChanges(for: entity)
            }
            catch{
                print(error)
            }
            }
        }
    }
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        if (self.currentEntities.count == 0 && !(self.entities.count == 0))
        {
            noDataLabel.text          = "No RFC found. Please, try another search."
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }
        if (self.entities.count == 0)
        {
            noDataLabel.text          = "No RFC processed by " + (UserDefaults.standard.string(forKey: "USER") ?? "")
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
        self.currentEntities.sort(by: {x, y -> Bool in
            x.objectID! > y.objectID!
        })
        return self.currentEntities.count
    }
    
    override func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tabBarController?.tabBar.items?[0].badgeValue = String(UserDefaults.standard.integer(forKey: "tobeapprovedcount"))
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath) as! FUIObjectTableViewCell
        let rfcqueryservice = self.currentEntities[indexPath.row]
        cell.headlineText = rfcqueryservice.description
        cell.accessoryType = .disclosureIndicator
        cell.subheadlineText = "Requester: " + rfcqueryservice.createdBy!
        cell.footnoteText = "Object ID: " + rfcqueryservice.objectID!
        if ((rfcqueryservice.status?.contains("E0003"))!){
        cell.statusText = "Rejected"
        cell.statusLabel.textColor = UIColor.preferredFioriColor(forStyle: .negative)
        }
        if ((rfcqueryservice.status?.contains("E0004"))!){
            cell.statusText = "Approved"
            cell.statusLabel.textColor = UIColor.preferredFioriColor(forStyle: .positive)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.currentEntities.count==0){
            return
        }
        
        if (isSearchBarOpen){
            self.closeSearchBar()
        }

        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = mainStoryBoard.instantiateViewController(withIdentifier: "RfCProcessedDetailViewController") as! RFCProcessedDetailViewController
        let selectedEntity = self.currentEntities[indexPath.row]
        let serviceSet = ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCQueryServiceSet
        let query = DataQuery().from(serviceSet).withKey(RfCQueryService.key(objectID: selectedEntity.objectID!, processType: selectedEntity.processType!))
        self.tabBarController?.tabBar.isHidden = true
        detailViewController.query = query
        detailViewController.allowsEditableCells = false
        detailViewController.navigationItem.leftItemsSupplementBackButton = true
        detailViewController.entitySetName = self.entitySetName
      self.navigationController?.show(detailViewController, sender: nil)
    }
    
    func fetchRfCQueryServiceSet(_ completionHandler: @escaping ([RfCQueryService]?, Error?) -> Void) {
        let status = RfCQueryService.status
        let queryLimit = DataQuery().selectAll().where(status.equal("E0004")||status.equal("E0003"))
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
        self.loadEntitiesBlock!() { entities, error in
            if let error = error {
                completionHandler(error)
                return
            }
            self.entities = entities!
            self.currentEntities = self.entities
            completionHandler(nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FUITableViewHeaderFooterView.reuseIdentifier) as! FUITableViewHeaderFooterView
        view.backgroundView = UIView()
        view.backgroundView?.backgroundColor = UIColor.preferredFioriColor(forStyle: .primary6)
        view.layer.borderWidth = 0.5
        view.isUserInteractionEnabled = false
        view.titleLabel.text = "Processed - " + (UserDefaults.standard.string(forKey: "USER") ?? "")
        return view
    }
    
    // MARK: - Table update
    
    func updateTable() {
        self.showFioriLoadingIndicator()
        let oq = OperationQueue()
        oq.addOperation({
            self.loadData {
                self.hideFioriLoadingIndicator()
            }
        })
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
                self.tableView.reloadData()
                self.logger.info("Table updated successfully!")
            })
        }
    }
    
    @objc func refresh() {
        let oq = OperationQueue()
        oq.addOperation({
            self.loadData {
                OperationQueue.main.addOperation({
                    self.refreshControl?.endRefreshing()
                })
            }
        })
    }
}

@available(iOS 11.0, *)
extension RFCProcessedMasterViewController: EntitySetUpdaterDelegate {
    func entitySetHasChanged() {
        self.updateTable()
    }
}
