//
//  ProfileViewController.swift
//  SnapchatClone
//
//  Created by Juliana Strawn on 4/25/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import QuartzCore
import Firebase

class ProfileViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var emailTextField : UITextField!
    var nameTextField : UITextField!
    var passwordTextField : UITextField!
    var loginRegisterSegmentedControl : UISegmentedControl!
    var loginRegisterButton : UIButton!
    var inputsContainerView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        checkIfUserLoggedIn()
        
    }
        
    func checkIfUserLoggedIn() {
        // if user is not logged in
        if FIRAuth.auth()?.currentUser?.uid == nil {
            
            self.usernameLabel.isHidden = true
            self.emailLabel.isHidden = true
            self.logoutButton.isHidden = true
            createLoginFields()
        } else {
            //if user is logged in, put name and email in labels
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observe(.value, andPreviousSiblingKeyWith: { (snapshot, error) in
                
                if let dictionary = snapshot.value as? [String : AnyObject] {
                    self.usernameLabel.text = dictionary["name"] as? String
                    self.emailLabel.text = dictionary["email"] as? String
                }
                
            }, withCancel: nil)
        }
    }
    
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    
    func handleLogin() {
        
        guard let email = emailTextField.text
            else { return }
        
        guard let password = passwordTextField.text
            else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error ?? "there was an error loggin in")
                return
            }
            
            // now that user is logged in, show their login info and hid all the other stuff
            self.loginRegisterSegmentedControl.isHidden = true
            self.inputsContainerView.isHidden = true
            self.nameTextField.isHidden = true
            self.emailTextField.isHidden = true
            self.passwordTextField.isHidden = true
            self.loginRegisterButton.isHidden = true
            
            self.usernameLabel.isHidden = false
            self.emailLabel.isHidden = false
            self.logoutButton.isHidden = false
            
            //self.usernameLabel.text = name
            self.emailLabel.text = email
            self.dismissKeyboard()
            
        })
    }
    
    
    func handleRegister() {
        
        guard let email = emailTextField.text
            else { return }
        
        guard let password = passwordTextField.text
            else { return }
        
        guard let name = nameTextField.text
            else { return }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error ?? "login error")
                return
            }
            
            guard let uid = user?.uid
                else { return }
            
            // succesfully authenticated user
            let ref = FIRDatabase.database().reference()
            let usersReference = ref.child("users").child(uid)
            
            let values = ["name" : name, "email" : email]
            
            usersReference.updateChildValues(values) { (updateError, ref) in
                if updateError != nil {
                    print(updateError ?? "error saving user credentials")
                    return
                }
            }
            
            print("Saved user succsessfully into Firebase Database")
            
            // now that user is logged in, show their login info and hid all the other stuff
            self.loginRegisterSegmentedControl.isHidden = true
            self.inputsContainerView.isHidden = true
            self.nameTextField.isHidden = true
            self.emailTextField.isHidden = true
            self.passwordTextField.isHidden = true
            self.loginRegisterButton.isHidden = true
            
            self.usernameLabel.isHidden = false
            self.emailLabel.isHidden = false
            self.logoutButton.isHidden = false
            
            self.usernameLabel.text = name
            self.emailLabel.text = email
            self.dismissKeyboard()
            PhotosViewController.getPhotos()

        })
        
        
        
    }
    
    
    @IBAction func handleLogout(_ sender: UIButton) {
        self.usernameLabel.isHidden = true
        self.emailLabel.isHidden = true
        self.logoutButton.isHidden = true
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        createLoginFields()
    }
    
    var inputsContainerViewHeightAnchor : NSLayoutConstraint?
    var nameTextFieldHeightAnhor : NSLayoutConstraint?
    var emailTextFieldHeightAnchor : NSLayoutConstraint?
    var passwordTextFieldHeightAnchor : NSLayoutConstraint?
    
    
    func createLoginFields() {
        
        // creating the container for inputs for user to login or register
        inputsContainerView = UIView()
        inputsContainerView.backgroundColor = UIColor.white
        inputsContainerView.layer.cornerRadius = 5
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputsContainerView)
        
        // containter constraints (x value, then y value, then width, then height)
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant:-24).isActive = true
        
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        // creating the register and login toggle
        loginRegisterSegmentedControl = UISegmentedControl(items: ["Login","Register"])
        loginRegisterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterSegmentedControl.selectedSegmentIndex = 1
        loginRegisterSegmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        loginRegisterSegmentedControl.tintColor = UIColor(r: 61, g: 91, b: 151)
        view.addSubview(loginRegisterSegmentedControl)
        
        //segmented control constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        // create login/register button
        loginRegisterButton = UIButton(type: .system)
        loginRegisterButton.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        loginRegisterButton.setTitle("Register", for: .normal)
        loginRegisterButton.setTitleColor(UIColor.white, for: .normal)
        loginRegisterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterButton.layer.cornerRadius = 5
        loginRegisterButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        view.addSubview(loginRegisterButton)
        
        // login/register button constraints (x value, then y value, then width, then height)
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant:12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // create text fields
        nameTextField = UITextField()
        nameTextField.placeholder = "Name"
        setTextFieldBorder(textField: nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        inputsContainerView.addSubview(nameTextField)
        
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        setTextFieldBorder(textField: emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        inputsContainerView.addSubview(emailTextField)
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        inputsContainerView.addSubview(passwordTextField)
        
        // text field constraints (x value, then y value, then width, then height)
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant:-24).isActive = true
        
        // change this one constraint if "login" is selected vs register
        nameTextFieldHeightAnhor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnhor?.isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 1).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant:-24).isActive = true
        
        // height constraint
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 1).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant:-24).isActive = true
        
        // height constraint
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // change height of container view if login is selected (100) else make it 150
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change height of name text field
        nameTextFieldHeightAnhor?.isActive = false
        nameTextFieldHeightAnhor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnhor?.isActive = true
        
        if title == "Login" {
            nameTextField.isHidden = true
        } else if title == "Register" {
            nameTextField.isHidden = false
        }
        
        // change height of email text field
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        // change height of password field
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        
    }
    
    func setTextFieldBorder(textField: UITextField) {
        
        textField.borderStyle = .none
        textField.layer.backgroundColor = UIColor.white.cgColor
        
        textField.layer.masksToBounds = false
        textField.layer.shadowColor = UIColor(r: 220, g: 220, b: 220).cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        textField.layer.shadowOpacity = 1.0
        textField.layer.shadowRadius = 0.0
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

