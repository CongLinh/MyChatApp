//
//  LoginController.swift
//  ChatApp
//
//  Created by nguyen van cong linh on 18/06/2018.
//  Copyright © 2018 nguyen van cong linh. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    let inputContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        return v
    }()
    
    lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(r: 200, g: 46, b: 49)
        btn.setTitle("Đăng ký", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        //print(123)
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("form not available")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("Errrrrror")
                return
            }
            //đăng nhập thành công 
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleRegister() {
        print("123")
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            print("form not available")
            return
        }
        
        //thêm user vào Authentication
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("error")
                return
            }
            
            guard let uid = user?.user.uid else {
                return
            }
            
            let ref = Database.database().reference(fromURL: "https://mychatapp-115a0.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print("err")
                    return
                }
                
                print("Saved user")
                self.dismiss(animated: true, completion: nil)
                
            })
            print(12345)
        }
        
    }
    
    let nameTextField: UITextField = {
        let nameTF = UITextField()
        nameTF.placeholder = "Tên tài khoản"
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        return nameTF
    }()
    
    let nameSeperatorView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    let emailTextField: UITextField = {
        let nameTF = UITextField()
        nameTF.placeholder = "Email"
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        return nameTF
    }()
    
    let emailSeperatorView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    let passwordTextField: UITextField = {
        let nameTF = UITextField()
        nameTF.placeholder = "Mật khẩu"
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        nameTF.isSecureTextEntry = true
        return nameTF
    }()
    
    let profileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "avatar")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 75
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Đăng nhập", "Đăng ký"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        //sc.layer.masksToBounds = true
        //sc.layer.cornerRadius = 15
        sc.addTarget(self, action: #selector(handleLoginRegisterChanged), for: .valueChanged)
        return sc
    }()
    
    @objc func handleLoginRegisterChanged() {
        //lấy ra tên của Segment
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        //gán tên cho Button
        registerButton.setTitle(title, for: .normal)
        
        //Thay đổi chiều cao InputContainerView
        inputContainerViewHeight?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        
        //KHI CHỌN SEGMENT THỨ 0, email và password TextFiled chiếm 1/2 chiều cao inputsContainerView
        //thay đổi chiều cao NameTextField
        nameTextFieldHeight?.isActive = false
        nameTextFieldHeight = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeight?.isActive = true
        
        //thay đổi chiều cao EmailTextField
        emailTextFieldHeight?.isActive = false
        emailTextFieldHeight = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeight?.isActive = true
        
        //thay đổi chiều cao PasswordTextField
        passTextFieldHeight?.isActive = false
        passTextFieldHeight = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passTextFieldHeight?.isActive = true
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(inputContainerView)
        view.addSubview(registerButton)
        
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        setupInputContainerView()
        setupRegisterButton()
    }
    
    func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    var inputContainerViewHeight: NSLayoutConstraint?
    var nameTextFieldHeight: NSLayoutConstraint?
    var emailTextFieldHeight: NSLayoutConstraint?
    var passTextFieldHeight: NSLayoutConstraint?

    func setupInputContainerView() {
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerViewHeight = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeight?.isActive = true
        
        
        
        
        inputContainerView.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextFieldHeight = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeight?.isActive = true
        
        inputContainerView.addSubview(nameSeperatorView)
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorView.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainerView.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextFieldHeight = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeight?.isActive = true
        
        inputContainerView.addSubview(emailSeperatorView)
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainerView.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passTextFieldHeight = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passTextFieldHeight?.isActive = true
    }
    
    func setupRegisterButton() {
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        registerButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }


}

//tự định nghĩa phương thức khởi tạo cho lớp UIColor:
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}












