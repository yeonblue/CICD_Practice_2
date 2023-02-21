//
//  ViewController.swift
//  RetireCalculator
//
//  Created by yeonBlue on 2023/02/13.
//

import UIKit
import AppCenter
import AppCenterCrashes
import AppCenterAnalytics

class ViewController: UIViewController {

    @IBOutlet weak var monthlyInvestmentsTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var retirementAgeTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var savingsTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Crashes.hasCrashedInLastSession {
            let alert = UIAlertController(title: "Sorry", message: "Sorry about that, an error occured.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        // AppCenter Event 탭에서 이벤트 tracking이 가능, count, user수 등을 알 수 있음
        Analytics.trackEvent("navigated_to_caluculator")
    }
    
    @IBAction func calculateButton_TouchUpInside(_ sender: Any) {
        // Crashes.generateTestCrash() // Firebase에서는 Crashlytics.crash()
        let current_age : Int? = Int(ageTextField.text!)
        let planned_retirement_age : Int? = Int(retirementAgeTextField.text!)

        let properties = ["current_age": String(current_age!),
                          "planned_retirement_age": String(planned_retirement_age!)]
        
        Analytics.trackEvent("calculate_retirement_amount", withProperties: properties)
    }
}

/*
 크래시가 났을 때 mdfind와 crash uuid를 통해 크래시 리포트 조회 가능
 mdfind "com_apple_xcode_dsym_uuids == E30FC309-DF7B-3C9F-8AC5-7F0F6047D65F"
 dSYM : debug symbol file
 */

/*
Firebase에도 Analytics에서 logEvent가 존재, appcenter의 trackEvent에 대응
 
     import FirebaseAnalytics

     // 사용자가 "Add to Cart" 버튼을 탭한 경우
     Analytics.logEvent("add_to_cart", parameters: [
       "item_id": "ABC123",
       "item_name": "iPhone X",
       "item_category": "Smartphones",
       "item_variant": "64GB"
     ])
 
 Crashes.hasCrashedInLastSession은 Firebase에서는 아래처럼 사용
 // 앱이 시작될 때 마지막 세션에서 충돌한 여부를 확인
 func checkLastSessionCrash() {
     if Crashlytics.crashlytics().didCrashDuringPreviousExecution() {
         print("앱이 마지막 세션에서 충돌했습니다.")
     } else {
         print("앱이 마지막 세션에서 충돌하지 않았습니다.")
     }
 }
 */
