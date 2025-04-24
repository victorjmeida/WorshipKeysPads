//
//  MainPadViewController.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 10/04/25.
//

import UIKit

class MainPadViewController: UIViewController {
    
    //Conectando a ViewController
    private let mainView = MainPadView()
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
