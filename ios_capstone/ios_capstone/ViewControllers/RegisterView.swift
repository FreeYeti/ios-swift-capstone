//
//  RegisterView.swift
//  ios_capstone
//
//  Created by Iulia on 2022/8/10.
//
import UIKit

class RegisterView: UIViewController {
    @IBOutlet weak var
        errorMsg:UILabel!
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SignUp"
    }
    
    func checkAndDisplayError()->Bool{
        let fname = self.firstNameInput?.text ?? ""
        let lname = self.lastNameInput?.text ?? ""
        let email = self.emailInput?.text ?? ""
        let password = self.passwordInput?.text ?? ""
        
        if !fname.isEmpty && !lname.isEmpty && !email.isEmpty && !password.isEmpty{
            if(password.count >= 8){
                return true
            }else{
                errorMsg.text = "length must be 8 of the password"

return false
            }
        }else{
            
            errorMsg.text = "Plese fill the all fields"
          return false
        }
    }

    @IBAction func register(_ sender: Any) {
        
        
        if(checkAndDisplayError() == false){return}
        
        let json: [String: Any] = ["email": emailInput.text!,
                                   "password": passwordInput.text!,
                                   "first_name": firstNameInput.text!,
                                   "last_name": lastNameInput.text!]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://capstone.freeyeti.net/api/account/signup/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                errorMsg.text = "Account not created"
                
                print(responseJSON)
            }
            errorMsg.text = "Account has been created successfully"
            print(responseJSON ?? "No JSON data to show you! :(")
        }
        
        task.resume()
    }
}
