//
// AppDelegate.swift
// Solution Manager
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 07/05/19
//

import SAPCommon
import SAPFiori
import SAPFioriFlows
import SAPFoundation
import SAPOData
import SAPOfflineOData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate, OnboardingManagerDelegate, ConnectivityObserver, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    public var loadEntitiesBlock: ((_ completionHandler: @escaping ([RfCQueryService]?, Error?) -> Void) -> Void)?
    private let logger = Logger.shared(named: "AppDelegateLogger")
    var zrequestforchangesrvEntities: ZREQUESTFORCHANGESRVEntities<OfflineODataProvider>!
    var zrequestforchangesrvEntitiesOnline: ZREQUESTFORCHANGESRVEntities<OnlineODataProvider>!
    private(set) var isOfflineStoreOpened = false
    
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set a FUIInfoViewController as the rootViewController, since there it is none set in the Main.storyboard
        UIApplication.shared.setMinimumBackgroundFetchInterval(1800)
        UIApplication.shared.registerForRemoteNotifications()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = FUIInfoViewController.createSplashScreenInstanceFromStoryboard()
        
        UINavigationBar.applyFioriStyle()
        
        ConnectivityReceiver.registerObserver(self)
        OnboardingManager.shared.delegate = self
        OnboardingManager.shared.onboardOrRestore()
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if (!ConnectivityUtils.isConnected()){
            completionHandler(.noData)
        }
        else {
            do{
                self.zrequestforchangesrvEntitiesOnline.fetchRfCApprove(matching: DataQuery().from(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCQueryServiceSet)) {_,_ in
                    self.zrequestforchangesrvEntities.download { error in
                        if let error = error {
                            self.logger.error("Offline Store download failed.", error: error)
                            print("Offline Store download failed.")
                        } else {
                            self.logger.info("Offline Store is downloaded.")
                            print("Offline Store is downloaded.")
                        }
                        self.setRootViewController(isBackground: false)
                        completionHandler(.newData)
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if (!ConnectivityUtils.isConnected()){
            completionHandler(.noData)
        }
        else {
            do{
                self.zrequestforchangesrvEntitiesOnline.fetchRfCApprove(matching: DataQuery().from(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCQueryServiceSet)) {_,_ in
                    self.zrequestforchangesrvEntities.download { error in
                        if let error = error {
                            self.logger.error("Offline Store download failed.", error: error)
                            print("Offline Store download failed.")
                        } else {
                            self.logger.info("Offline Store is downloaded.")
                            print("Offline Store is downloaded.")
                        }
                        self.setRootViewController(isBackground: false)
                        completionHandler(.newData)
                    }
                }
            }
        }
    }
    
    // To only support portrait orientation during onboarding
    func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {
        switch OnboardingFlowController.presentationState {
        case .onboarding, .restoring:
            return .portrait
        default:
            return .portrait
        }
    }
    
    // Delegate to OnboardingManager.
    func applicationDidEnterBackground(_: UIApplication) {
        OnboardingManager.shared.applicationDidEnterBackground()
        //self.closeOfflineStore()
    }
    
    // Delegate to OnboardingManager.
    func applicationWillEnterForeground(_: UIApplication) {
        OnboardingManager.shared.applicationWillEnterForeground {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.closeOfflineStore()
    }
    
    func onboarded(onboardingContext: OnboardingContext, onboarding: Bool) {
        // Adjust this path so it can be called after authentication and returns an HTTP 200 code. This is used to validate the authentication was successful.
        SettingsBundleHelper.checkAndExecuteSettings()
        let configurationURL = URL(string:"https://mobile-lca560d580.hana.ondemand.com/com.ferrero.sap.SolutionManager")!
        
        self.getUserInfo(onboardingContext, configurationURL, onboarding)
        
        self.registerForRemoteNotification(onboardingContext.sapURLSession, onboardingContext.info[.sapcpmsSettingsParameters] as! SAPcpmsSettingsParameters)
    }
    
    private func setRootViewController(isBackground: Bool) {
        DispatchQueue.main.sync {
            if (isBackground){
                //FUIToastMessage.show(message: "Sync offline completed!")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            }
            else {
                let splitViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "containerView")
                //splitViewController.modalPresentationStyle = .currentContext
                self.window!.rootViewController = splitViewController
            }
        }
    }
    
    // MARK: - Split view
    
    func splitViewController(_: UISplitViewController, collapseSecondary _: UIViewController, onto _: UIViewController) -> Bool {
        // The first Collection will be selected automatically, so we never discard showing the secondary ViewController
        return false
    }
    
    // MARK: - Remote Notification handling
    
    private var deviceToken: Data?
    
    func application(_: UIApplication, willFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UIApplication.shared.registerForRemoteNotifications()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
            // Enable or disable features based on authorization.
        }
        center.delegate = self
        return true
    }
    
    
    // Called to let your app know which action was selected by the user for a given notification.
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.logger.info("App opened via user selecting notification: \(response.notification.request.content.body)")
        // Here is where you want to take action to handle the notification, maybe navigate the user to a given screen.
        completionHandler()
    }
    
    // Called when a notification is delivered to a foreground app.
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        self.logger.info("Remote Notification arrived while app was in foreground: \(notification.request.content.body)")
        // Currently we are presenting the notification alert as the application were in the background.
        // If you have handled the notification and do not want to display an alert, call the completionHandler with empty options: completionHandler([])
        completionHandler([.alert, .sound])
    }
    
    func registerForRemoteNotification(_ urlSession: SAPURLSession, _ settingsParameters: SAPcpmsSettingsParameters) {
        guard let deviceToken = self.deviceToken else {
            // Device token has not been acquired
            print("Device token has not been acquired")
            return
        }
        
        let remoteNotificationClient = SAPcpmsRemoteNotificationClient(sapURLSession: urlSession, settingsParameters: settingsParameters)
        remoteNotificationClient.registerDeviceToken(deviceToken) { error in
            if let error = error {
                self.logger.error("Register DeviceToken failed", error: error)
                return
            }
            self.logger.info("Register DeviceToken succeeded")
        }
    }
    
    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.deviceToken = deviceToken
    }
    
    
    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        self.logger.error("Failed to register for Remote Notification", error: error)
    }
    
    // MARK: - Configure Offline OData
    
    private func configureOData(_ urlSession: SAPURLSession, _ serviceRoot: URL, _ onboarding: Bool, manager: String) {
        let changeManager = RfCQueryService.changeManager
        let queryManager = DataQuery().selectAll().where(changeManager.equal(UserDefaults.standard.string(forKey: "USER")!))
        var offlineParameters = OfflineODataParameters()
        offlineParameters.enableRepeatableRequests = true
        // Setup an instance of delegate. See sample code below for definition of OfflineODataDelegateSample class.
        let delegate = OfflineODataDelegateSample()
        let offlineODataProvider = try! OfflineODataProvider(serviceRoot: serviceRoot, parameters: offlineParameters, sapURLSession: urlSession, delegate: delegate)
        
        if onboarding {
            do {
                if (ConnectivityUtils.isConnected()){
                    do{
                        try offlineODataProvider.clear()
                    }
                    catch {
                        print("error")
                    }
                }
                try offlineODataProvider.add(definingQuery: OfflineODataDefiningQuery(name:ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCQueryServiceSet.localName , query: "/\(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCQueryServiceSet.localName)\(queryManager)", automaticallyRetrievesStreams: false))
            } catch {
                self.logger.error("Failed to add defining query for Offline Store initialization", error: error)
            }
        }
        self.zrequestforchangesrvEntities = ZREQUESTFORCHANGESRVEntities(provider: offlineODataProvider)
        
    }
    
    fileprivate func showOfflineODataError(_ error: OfflineODataError, message: String) {
        DispatchQueue.main.async(execute: {
            let errorOfflineInfoVC = FUIInfoViewController.createSplashScreenInstanceFromStoryboard()
            errorOfflineInfoVC.informationTextView.text = "\(message): \(error)"
            errorOfflineInfoVC.informationTextView.textColor = UIColor.black
            errorOfflineInfoVC.informationTextView.textAlignment = .center
            errorOfflineInfoVC.informationTextView.isHidden = false
            errorOfflineInfoVC.loadingIndicatorView.dismiss()
            self.window!.rootViewController = errorOfflineInfoVC
        })
    }
    
    private func performOfflineRefresh(isBackground: Bool) {
        //self.uploadOfflineStore()
        self.downloadOfflineStore(isBackground: isBackground)
    }
    
    public func openOfflineStore(onboarding: Bool, isBackground: Bool) {
        print("passo 1")
        if !self.isOfflineStoreOpened {
            print("passo 2")
            // The OfflineODataProvider needs to be opened before performing any operations.
            self.zrequestforchangesrvEntities.open { error in
                if let error = error {
                    self.logger.error("Could not open offline store.", error: error)
                    self.showOfflineODataError(error, message: "Could not open offline store")
                    return
                }
                print("passo 3")
                self.isOfflineStoreOpened = true
                self.logger.info("Offline store opened.")
                if !onboarding {
                    print("passo 4")
                    // You might want to consider doing the synchronization based on an explicit user interaction instead of automatically synchronizing during startup
                    self.performOfflineRefresh(isBackground: isBackground)
                } else {
                    print("passo 5")
                    self.setRootViewController(isBackground: isBackground)
                }
            }
        } else if !onboarding {
            print("passo 6")
            // You might want to consider doing the synchronization based on an explicit user interaction instead of automatically synchronizing during startup
            self.performOfflineRefresh(isBackground: isBackground)
        }
    }
    
    public func closeOfflineStore() {
        if self.isOfflineStoreOpened {
            do {
                // the Offline store should be closed when it is no longer used.
                try self.zrequestforchangesrvEntities.close()
                self.isOfflineStoreOpened = false
            } catch {
                self.logger.error("Offline Store closing failed.")
            }
        }
        print("Offline Store closed.")
        self.logger.info("Offline Store closed.")
    }
    
    private func downloadOfflineStore(isBackground: Bool) {
        if !self.isOfflineStoreOpened {
            self.logger.error("Offline Store still closed")
            print("Offline Store still closed")
            return
        }
        print("passo 7")
        DispatchQueue.global().async {
            do{
                try self.zrequestforchangesrvEntitiesOnline.fetchRfCApprove(matching: DataQuery().from(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCQueryServiceSet))
            }
                
            catch{
                print("error")
            }
        }
        
        // the download function updates the client’s offline store from the backend.
        self.zrequestforchangesrvEntities.download { error in
            if let error = error {
                self.logger.error("Offline Store download failed.", error: error)
                print("Offline Store download failed.")
                if (ConnectivityUtils.isConnected()){
                    DispatchQueue.main.async {
                        FUIToastMessage.show(message: "Offline Store download failed:\nInternal server error.",icon: FUIIconLibrary.indicator.veryHighPriority,withDuration: 2.5, maxNumberOfLines: 15)
                    }
                }
                
            } else {
                self.logger.info("Offline Store is downloaded.")
                print("Offline Store is downloaded.")
            }
            self.setRootViewController(isBackground: isBackground)
        }
    }
    
    private func uploadOfflineStore() {
        if !self.isOfflineStoreOpened {
            self.logger.error("Offline Store still closed")
            print("Offline Store still closed")
            return
        }
        print("passo 5")
        // the upload function updates the backend from the client’s offline store.
        
        self.zrequestforchangesrvEntities.upload { error in
            if let error = error {
                self.logger.error("Offline Store upload failed.", error: error)
                print("Offline Store upload failed.")
                return
            }
            self.logger.info("Offline Store is uploaded.")
            print("Offline Store is uploaded.")
        }
        print("passo 6")
    }
    
    
    func getUserInfo(_ onBoardingContext: OnboardingContext, _ serviceRoot: URL, _ onboarding: Bool) {
        let userRoles = SAPcpmsUserRoles(sapURLSession: onBoardingContext.sapURLSession, settingsParameters: onBoardingContext.info[.sapcpmsSettingsParameters] as! SAPcpmsSettingsParameters)
        
        userRoles.load{ userInfo, error in
            var username = ""
            if (ConnectivityUtils.isConnected()){
                username = userInfo?.userName.components(separatedBy: "@")[0].uppercased() ?? ""
                let nameSurnameFirst = userInfo?.givenName ?? ""
                let nameSurnameSecond = userInfo?.familyName ?? ""
                let nameSurname = nameSurnameFirst + " " + nameSurnameSecond
                UserDefaults.standard.set(nameSurname, forKey: "NAMESURNAME")
                UserDefaults.standard.set(userInfo?.emails?[0]["value"], forKey: "EMAIL")
                UserDefaults.standard.set(username, forKey: "USER")
                UserDefaults.standard.synchronize()
            }
            else{
                username = UserDefaults.standard.string(forKey: "USER") ?? ""
            }
            
            self.configureEntities(onBoardingContext.sapURLSession, serviceRoot, onboarding)
            self.configureOData(onBoardingContext.sapURLSession, serviceRoot, onboarding, manager: username)
            self.openOfflineStore(onboarding: onboarding, isBackground: false)
        }
    }
    
    func configureEntities(_ urlSession: SAPURLSession, _ serviceRoot: URL, _ onboarding: Bool){
        self.zrequestforchangesrvEntities = nil
        do {
            var entities = [RfCQueryService]()
            let changeManager = RfCQueryService.changeManager
            let queryLimit = DataQuery().selectAll().where(changeManager.equal(UserDefaults.standard.string(forKey: "USER")!))
            let odataProvider = OnlineODataProvider(serviceName: "ZREQUESTFORCHANGESRVEntities", serviceRoot: serviceRoot, sapURLSession: urlSession)
            odataProvider.serviceOptions.checkVersion = false
            
            self.zrequestforchangesrvEntitiesOnline = ZREQUESTFORCHANGESRVEntities(provider: odataProvider)
            self.zrequestforchangesrvEntitiesOnline.provider.networkOptions.tunneledMethods.append("MERGE")
            func fetchRfCQueryServiceSet(_ completionHandler: @escaping ([RfCQueryService]?, Error?) -> Void) {
                do {
                    self.zrequestforchangesrvEntitiesOnline!.fetchRfCQueryServiceSet(matching: queryLimit) { rfCQueryServiceSet, error in
                        if error == nil {
                            completionHandler(rfCQueryServiceSet, nil)}
                        else {
                            completionHandler(nil, error)
                        }
                    }
                }
            }
            self.loadEntitiesBlock = nil
            self.loadEntitiesBlock = fetchRfCQueryServiceSet(_:)
        }
    }
    
    
    // MARK: - ConnectivityObserver implementation
    
    func connectionEstablished() {
        DispatchQueue.global().async {
            let defaults = UserDefaults.standard
            let queryArray = defaults.array(forKey: "QueryInputArray") as? [[String]]
            if (queryArray != nil){
                do{
                    for queryInput in queryArray! {
                        let approveSet = ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCApproveSet
                        let keyApproveReject = RfCApprove.key(objectID: queryInput[0], processType: queryInput[1], operationType: queryInput[2])
                        let queryApproveReject = DataQuery().from(approveSet).withKey(keyApproveReject)
                        try self.zrequestforchangesrvEntitiesOnline!.fetchRfCApprove(matching: queryApproveReject)
                        print(queryApproveReject)
                        
                    }
                    let arraynull = [[String]]()
                    defaults.set(arraynull, forKey: "QueryInputArray")
                    defaults.synchronize()
                }
                catch {
                    return
                }
            }
        }
    }
    
    
    func connectionChanged(_ previousReachabilityType: ReachabilityType, reachabilityType _: ReachabilityType) {
        // connection changed
        if case previousReachabilityType = ReachabilityType.offline {
            // connection established
        }
    }
    
    func connectionLost() {
        // connection lost
    }
}



class OfflineODataDelegateSample: OfflineODataDelegate {
    private let logger = Logger.shared(named: "AppDelegateLogger")
    
    public func offlineODataProvider(_: OfflineODataProvider, didUpdateDownloadProgress progress: OfflineODataProgress) {
        self.logger.info("downloadProgress: \(progress.bytesSent)  \(progress.bytesReceived)")
        //print("downloadProgress: \(progress.bytesSent)  \(progress.bytesReceived)")
        
    }
    
    public func offlineODataProvider(_: OfflineODataProvider, didUpdateFileDownloadProgress progress: OfflineODataFileDownloadProgress) {
        self.logger.info("downloadProgress: \(progress.bytesReceived)  \(progress.fileSize)")
        //print("downloadProgress: \(progress.bytesReceived)  \(progress.fileSize)")
    }
    
    public func offlineODataProvider(_: OfflineODataProvider, didUpdateUploadProgress progress: OfflineODataProgress) {
        self.logger.info("downloadProgress: \(progress.bytesSent)  \(progress.bytesReceived)")
    }
    
    public func offlineODataProvider(_: OfflineODataProvider, requestDidFail request: OfflineODataFailedRequest) {
        self.logger.info("requestFailed: \(request.httpStatusCode)")
    }
    
    // The OfflineODataStoreState is a Swift OptionSet. Use the set operation to retrieve each setting.
    private func storeState2String(_ state: OfflineODataStoreState) -> String {
        var result = ""
        if state.contains(.opening) {
            result = result + ":opening"
        }
        if state.contains(.open) {
            result = result + ":open"
        }
        if state.contains(.closed) {
            result = result + ":closed"
        }
        if state.contains(.downloading) {
            result = result + ":downloading"
        }
        if state.contains(.uploading) {
            result = result + ":uploading"
        }
        if state.contains(.initializing) {
            result = result + ":initializing"
        }
        if state.contains(.fileDownloading) {
            result = result + ":fileDownloading"
        }
        if state.contains(.initialCommunication) {
            result = result + ":initialCommunication"
        }
        return result
    }
    
    public func offlineODataProvider(_: OfflineODataProvider, stateDidChange newState: OfflineODataStoreState) {
        let stateString = storeState2String(newState)
        self.logger.debug("stateChanged: \(stateString)")
    }
}
