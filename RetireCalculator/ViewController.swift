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
        // MSCrashes.generateTestCrash()
        let current_age : Int? = Int(ageTextField.text!)
        let planned_retirement_age : Int? = Int(retirementAgeTextField.text!)
        let monthly_investment : Float? = Float(monthlyInvestmentsTextField.text!)
        let current_savings : Float? = Float(savingsTextField.text!)
        let interest_rate : Float? = Float(interestRateTextField.text!)
        
        let retirement_amount = calculateRetirementAmount(current_age: current_age!, retirement_age: planned_retirement_age!, monthly_investment: monthly_investment!, current_savings: current_savings!, interest_rate: interest_rate!)
        
        resultLabel.text = "If you save $\(monthly_investment!) every month for \(planned_retirement_age! - current_age!) years, and invest that money plus your current investment of $\(current_savings!) at a \(interest_rate!)% anual interest rate, you will have $\(retirement_amount) by the time you are \(planned_retirement_age!) years old."
        
        let properties = ["current_age": String(current_age!),
                          "planned_retirement_age": String(planned_retirement_age!)]
        
        Analytics.trackEvent("calculate_retirement_amount", withProperties: properties)
    }
    
    func calculateRetirementAmount(current_age: Int, retirement_age : Int, monthly_investment: Float, current_savings: Float, interest_rate: Float) -> Double {
        let months_until_retirement = (retirement_age - current_age) * 12
        
        var retirement_amount = Double(current_savings) * pow(Double(1+interest_rate/100/12), Double(months_until_retirement))
        
        for i in 1...months_until_retirement {
            let monthly_rate = interest_rate / 100 / 12
            retirement_amount += Double(monthly_investment) * pow(Double(1+monthly_rate), Double(i))
        }
        
        return retirement_amount
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

/*
 CI/CD 준비
 1. Master Branchsms 안전하게 protect 필요
 2. dev - feature branchs 구현 예정
 3. Feedback loop가 빨라짐
 4. Pull Request를 이용 (central, collaborate)
 5. test를 포함
 */
