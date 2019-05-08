//
//  UpsellViewController.swift
//  SwiftExample
//
//  Created by Ryan Kotzebue on 1/9/19.
//  Copyright © 2019 RevenueCat. All rights reserved.
//

import UIKit
import Purchases

class UpsellViewController: UIViewController {
    
    @IBOutlet weak var annualCatsButton: UIButton!
    @IBOutlet weak var monthlyCatsButton: UIButton!
    @IBOutlet weak var lifetimeCatsButton: UIButton!

    @IBOutlet weak var annualLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var monthlyLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lifetimeLoadingIndicator: UIActivityIndicatorView!
    
    var annualCatProduct : SKProduct?
    var monthlyCatProduct : SKProduct?
    var lifetimeCatProduct : SKProduct?
    
    var annualCatButtonTitle = ""
    var lifetimeCatButtonTitle = ""
    var monthlyCatButtonTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        annualCatsButton.addTarget(self, action: #selector(buyAnnualCats), for: .touchDown)
        monthlyCatsButton.addTarget(self, action: #selector(buyMonthlyCats), for: .touchDown)
        lifetimeCatsButton.addTarget(self, action: #selector(buyLifetimeCats), for: .touchDown)
        
        setState(loading: true)

        Purchases.shared.entitlements { (entitlements, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            
            guard let pro = entitlements?["pro_cat"] else {
                print("Error finding pro_cat entitlement")
                return
            }
            guard let monthly = pro.offerings["monthly_cats"] else {
                print("Error finding monthly_cats offering")
                return
            }
            guard let annual = pro.offerings["annual_cats"] else {
                print("Error finding annual_cats offering")
                return
            }
            guard let lifetime = pro.offerings["lifetime_cats"] else {
                print("Error finding annual_cats offering")
                return
            }
            
            guard let monthlyProduct = monthly.activeProduct else {
                print("Error finding monthly active product")
                return
            }
            guard let annualProduct = annual.activeProduct else {
                print("Error finding annual active product")
                return
            }
            guard let lifetimeProduct = lifetime.activeProduct else {
                print("Error finding lifetime active product")
                return
            }
            
            self.monthlyCatProduct = monthlyProduct
            self.annualCatProduct = annualProduct
            self.lifetimeCatProduct = lifetimeProduct
            
            print("All entitlements fetched successfully 🎉")
            
            // set up the buttons
            self.annualCatButtonTitle = "Buy Annual - \(annualProduct.priceLocale.currencySymbol ?? "")\(annualProduct.price)"
            self.monthlyCatButtonTitle = "Buy Monthly - \(monthlyProduct.priceLocale.currencySymbol ?? "")\(monthlyProduct.price)"
            self.lifetimeCatButtonTitle = "Buy Lifetime - \(lifetimeProduct.priceLocale.currencySymbol ?? "")\(lifetimeProduct.price)"
            self.setState(loading: false)
        }
    }
    
    @objc func buyAnnualCats() {
        guard let product = annualCatProduct else { return }
        makePurchase(catProduct: product)
    }
    
    @objc func buyMonthlyCats() {
        guard let product = monthlyCatProduct else { return }
        makePurchase(catProduct: product)
    }
    
    @objc func buyLifetimeCats() {
        guard let product = lifetimeCatProduct else { return }
        makePurchase(catProduct: product)
    }
    
    func makePurchase(catProduct: SKProduct) {
        
        setState(loading: true)
        Purchases.shared.makePurchase(catProduct) { (transaction, purchaserInfo, error, userCancelled) in
            if let e = error {
                print("PURCHASE ERROR: - \(e.localizedDescription)")
                
            } else if purchaserInfo?.activeEntitlements.contains("pro_cat") ?? false {
                print("Purchased Pro Cats 🎉")
                
                self.showCatContent()
            }
            
            self.setState(loading: false)
        }
    }
    
    @IBAction func skipBuyingCats(_ sender: Any) {
        showCatContent()
    }
    
    func showCatContent() {
        navigationController?.pushViewController(
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cats"),
            animated: true)
    }
    
    func setState(loading: Bool) {
        
        if loading {
            annualLoadingIndicator.startAnimating()
            monthlyLoadingIndicator.startAnimating()
            lifetimeLoadingIndicator.startAnimating()
            
            annualCatsButton.isEnabled = false
            monthlyCatsButton.isEnabled = false
            lifetimeCatsButton.isEnabled = false
            
            annualCatsButton.setTitle(nil, for: .normal)
            monthlyCatsButton.setTitle(nil, for: .normal)
            lifetimeCatsButton.setTitle(nil, for: .normal)
        } else {
            annualLoadingIndicator.stopAnimating()
            monthlyLoadingIndicator.stopAnimating()
            lifetimeLoadingIndicator.stopAnimating()
            
            annualCatsButton.isEnabled = true
            monthlyCatsButton.isEnabled = true
            lifetimeCatsButton.isEnabled = true
            
            annualCatsButton.setTitle(annualCatButtonTitle, for: .normal)
            monthlyCatsButton.setTitle(monthlyCatButtonTitle, for: .normal)
            lifetimeCatsButton.setTitle(lifetimeCatButtonTitle, for: .normal)
        }
    }
}
