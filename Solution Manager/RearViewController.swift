//
//  RearViewController.swift
//  Solution Manager
//
//  Created by Dario Arrigo on 30/09/2019.
//  Copyright © 2019 SAP. All rights reserved.
//

import Foundation
import SAPCommon
import SAPFiori
import SAPFoundation
import SAPOData
import SAPOfflineOData
import SAPFioriFlows
import MessageUI

@available(iOS 13.0, *)
class RearViewController: UIViewController, SAPFioriLoadingIndicator, UITableViewDelegate, UITableViewDataSource {
    
    var profileHeader: FUIProfileHeader!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var myTableView: UITableView!
    var loadingIndicator: FUILoadingIndicatorView?
    let version = UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.appVersionKey)
    let build = UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.buildKey)
    let environment = "Development"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let keyValueCell = tableView.dequeueReusableCell(withIdentifier: FUIKeyValueFormCell.reuseIdentifier, for: indexPath) as! FUIKeyValueFormCell
            keyValueCell.keyName = "Version"
            keyValueCell.selectionStyle = .none
            keyValueCell.isUserInteractionEnabled = false
            keyValueCell.value = version!
            keyValueCell.maxNumberOfLines = 1
            return keyValueCell
            
        case 1:
            let keyValueCell = tableView.dequeueReusableCell(withIdentifier: FUIKeyValueFormCell.reuseIdentifier, for: indexPath) as! FUIKeyValueFormCell
            keyValueCell.keyName = "Build"
            keyValueCell.selectionStyle = .none
            keyValueCell.isUserInteractionEnabled = false
            keyValueCell.value = build!
            keyValueCell.maxNumberOfLines = 1
            return keyValueCell
            
        case 2:
            let keyValueCell = tableView.dequeueReusableCell(withIdentifier: FUIKeyValueFormCell.reuseIdentifier, for: indexPath) as! FUIKeyValueFormCell
            keyValueCell.keyName = "Environment"
            keyValueCell.isUserInteractionEnabled = false
            keyValueCell.selectionStyle = .none
            //keyValueCell.isEditable = false
            keyValueCell.value = environment
            keyValueCell.maxNumberOfLines = 2
            return keyValueCell
            
        case 3:
            let titleCell = tableView.dequeueReusableCell(withIdentifier: FUITitleFormCell.reuseIdentifier, for: indexPath) as! FUITitleFormCell
            titleCell.value = "       Support"
            titleCell.imageView?.image = UIImage(named: "email")
            titleCell.selectionStyle = .blue
            titleCell.accessoryType = .disclosureIndicator
            titleCell.isEditable = false
            return titleCell
            
        case 4:
            let titleCell = tableView.dequeueReusableCell(withIdentifier: FUITitleFormCell.reuseIdentifier, for: indexPath) as! FUITitleFormCell
            titleCell.selectionStyle = .blue
            titleCell.value = "       Logout"
            titleCell.imageView?.image = UIImage(named: "exit")
            titleCell.isEditable = false
            return titleCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 3:
            self.sendEmail()
        case 4:
            self.logout()
        default:
            return
        }
    }
    
    func logout(){
        let alertController = UIAlertController(
            title: "Confirm Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: UIAlertController.Style.alert
        )
        let confirmAction = UIAlertAction(
        title: "Ok", style: UIAlertAction.Style.default) { (action) in
            self.logoutAction()
        }
        let cancelAction = UIAlertAction(
        title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            return
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func logoutAction(){
        let sapURLSession = OnboardingManager.shared.sapURLSession
        let logoutURL = URL(string: "https://mobile-lca560d580.hana.ondemand.com/mobileservices/sessions/logout")!
        var logoutRequest = URLRequest(url: logoutURL)
        logoutRequest.httpMethod = SAPURLSession.HTTPMethod.post
        
        sapURLSession?.dataTask(with: logoutRequest){data, response, error in
            if error == nil {
                print("eccomiiiii")
                DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    UserDefaults.standard.removeObject(forKey: "USER")
                    UserDefaults.standard.removeObject(forKey: "NAMESURNAME")
                    UserDefaults.standard.removeObject(forKey: "EMAIL")
                    UserDefaults.standard.removeObject(forKey: "approvedcount")
                    UserDefaults.standard.removeObject(forKey: "rejectedcount")
                    UserDefaults.standard.removeObject(forKey: "tobeapprovedcount")
                    UserDefaults.standard.removeObject(forKey: "keyOnboardingID")
                    UserDefaults.standard.synchronize()
                    self.appDelegate.closeOfflineStore()
                    URLCache.shared.removeAllCachedResponses()
                    HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
                    OnboardingManager.shared.onboardOrRestore()
                }
            }
        }.resume()
    }
    
    func sendEmail(){
        let emailTo = "GSCMobileCompetenceCenter@ferrero.com"
        let subjectFirstPart = "Problem%20on%20version%20" + version! + "%20in%20"
        let subjectSecondPart = environment + "%20environment"
        let subject = subjectFirstPart + subjectSecondPart
        let urlString = "ms-outlook://compose?to=" + emailTo + "&subject=" + subject
        print(urlString)
        
        if (UIApplication.shared.canOpenURL(URL(string: urlString)!)){
            UIApplication.shared.open(URL(string: urlString)!)
            HamburgerMenu().closeSideMenu()
        }
        else {
            FUIToastMessage.show(message: "Add an outlook account!", icon: .add)
        }
    }
    
    
    func setTableView(){
        myTableView.estimatedRowHeight = 44
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.separatorStyle = .none
        myTableView.register(FUITitleFormCell.self, forCellReuseIdentifier: FUITitleFormCell.reuseIdentifier)
        myTableView.register(FUIKeyValueFormCell.self, forCellReuseIdentifier: FUIKeyValueFormCell.reuseIdentifier)
        setupProfileHeader()
        myTableView.tableHeaderView = profileHeader
    }
    
    func setupProfileHeader() {
        // Profile Header
        profileHeader = FUIProfileHeader()
        profileHeader.imageView.image = UIImage(named: "profile")
        
        profileHeader.headlineText = UserDefaults.standard.string(forKey: "NAMESURNAME")!
        profileHeader.subheadlineText = UserDefaults.standard.string(forKey: "USER")!
        profileHeader.descriptionText = (UserDefaults.standard.string(forKey: "EMAIL") ?? "")
    }
    
    
}
