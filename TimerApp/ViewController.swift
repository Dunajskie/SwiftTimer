//
//  ViewController.swift
//  TimerApp
//
//  Created by Michał Dunajski on 03/08/2021.
//

import UIKit

class ViewController: UIViewController {
    
    let circle = CounterView()
    let button = UIButton()
    var islessthan3 = true
    var angle:CGFloat?
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 1.0
        view.backgroundColor = .darkGray
        view.addSubview(circle)
        view.addSubview(button)
        setupconstrains()
        setupxd()
    }

    func setupconstrains(){
        
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 300).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 300).isActive = true
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setupxd(){
        button.backgroundColor = .orange
        button.setTitle("START", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        if button.currentTitle == "START"{
            if circle.seconds > 3{
                 angle = CGFloat((circle.timeseconds-3) * Double.pi/6)
                 islessthan3 = false
            }
            else{
                 angle = CGFloat(Double.pi * 2 - ((3-circle.timeseconds) * Double.pi/6))
                 islessthan3 = true
            }
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            button.setTitle("STOP", for: .normal)
            button.backgroundColor = .red
            view.backgroundColor = .gray
            circle.counterColor = .white
            circle.outlineColor = .darkGray
            circle.gestureOpen = false
            circle.ispointing = false
        }
        
        else{
            timer.invalidate()
            button.setTitle("START", for: .normal)
            button.backgroundColor = .orange
            view.backgroundColor = .darkGray
            circle.counterColor = .lightGray
            circle.outlineColor = .white
            circle.gestureOpen = true
            circle.timeseconds = circle.seconds
            circle.ispointing = true
            if circle.seconds > 3{
                circle.angleend = CGFloat((circle.timeseconds-3) * Double.pi/6)
                islessthan3 = false
            }
            else{
                circle.angleend = CGFloat(Double.pi * 2 - ((3-circle.timeseconds) * Double.pi/6))
                islessthan3 = true
            }
        }
    }
    
    @objc func updateCounter() {
        if circle.timeseconds > 0.01 {
            if islessthan3{
                circle.angleend = CGFloat(angle! - (angle! - CGFloat(Double.pi * 3/2)) * CGFloat(Double(1-circle.timeseconds/circle.seconds)))
            }
            else{
                circle.angleend = CGFloat(angle! - (angle! + CGFloat(Double.pi/2)) * CGFloat(Double(1-circle.timeseconds/circle.seconds)))
            }
            circle.timeseconds -= 0.01
         }
        else{
            timer.invalidate()
            button.setTitle("START", for: .normal)
            button.backgroundColor = .orange
            view.backgroundColor = .darkGray
            circle.counterColor = .lightGray
            circle.outlineColor = .white
            circle.gestureOpen = true
            circle.timeseconds = circle.seconds
            circle.ispointing = true
            if circle.seconds > 3{
                circle.angleend = CGFloat((circle.timeseconds-3) * Double.pi/6)
                islessthan3 = false
            }
            else{
                circle.angleend = CGFloat(Double.pi * 2 - ((3-circle.timeseconds) * Double.pi/6))
                 islessthan3 = true
            }
            
            blink()
        }
    }
    
    func blink() {
        UIView.animate(withDuration: 1.5, delay: 0.2, options: .transitionCrossDissolve, animations: {self.view.alpha = 0.0})
        UIView.animate(withDuration: 1.5, delay: 0.0, options: .transitionCrossDissolve, animations: {self.view.alpha = 1.0})
        }
}



