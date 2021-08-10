//
//  ViewController.swift
//  TimerApp
//
//  Created by Michał Dunajski on 03/08/2021.
//

import UIKit

class ViewController: UIViewController {
    let circleView = CounterView()
    let button = UIButton()
    var isLessthan3 = true
    var angle: CGFloat?
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 1.0
        view.backgroundColor = UIColor(named: "Grejfrut")!
        view.addSubview(circleView)
        view.addSubview(button)
        setupConstrains()
        setupOptions()
    }

    func setupConstrains() {
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 330).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 330).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 330).isActive = true
        button.heightAnchor.constraint(equalToConstant: 65).isActive = true
    }
    func setupOptions() {
        button.backgroundColor = UIColor(named: "DarkYellow")!
        button.setTitle("START", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23.0)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    @objc func buttonAction(sender: UIButton!) {
        if button.currentTitle == "START"{
            if circleView.seconds > 3 {
                 angle = CGFloat((circleView.timerSeconds-3) * Double.pi/6)
                 isLessthan3 = false
            } else {
                 angle = CGFloat(Double.pi * 2 - ((3-circleView.timerSeconds) * Double.pi/6))
                 isLessthan3 = true
            }
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            button.setTitle("STOP", for: .normal)
            button.backgroundColor = UIColor(named: "Grejfrut")!
            view.backgroundColor = UIColor(named: "DarkBlue")!
            circleView.counterColor = UIColor(named: "LightDarkBlue")!
            circleView.outlineColor = UIColor(named: "DarkBlue")!
            circleView.gestureOpen = false
            circleView.isPointing = false
        } else {
            timer.invalidate()
            button.setTitle("START", for: .normal)
            button.backgroundColor = UIColor(named: "DarkYellow")!
            view.backgroundColor = UIColor(named: "Grejfrut")!
            circleView.counterColor = UIColor(named: "LightGrejfrut")!
            circleView.outlineColor = UIColor(named: "Grejfrut")!
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateComeback), userInfo: nil, repeats: true)
            circleView.gestureOpen = true
        }
    }
    @objc func updateComeback() {
        circleView.timerSeconds += 0.07
        let destination = CGFloat((circleView.timerSeconds-3) * Double.pi/6)
        if circleView.timerSeconds < circleView.seconds {
            circleView.pointingAngle += (destination - circleView.pointingAngle)*CGFloat((circleView.timerSeconds / circleView.seconds))
        } else {
            timer.invalidate()
            circleView.timerSeconds = circleView.seconds
            circleView.isPointing = true
            if circleView.seconds > 3 {
                circleView.pointingAngle = CGFloat((circleView.timerSeconds-3) * Double.pi/6)
                isLessthan3 = false
            } else {
                circleView.pointingAngle = CGFloat(Double.pi * 2 - ((3-circleView.timerSeconds) * Double.pi/6))
                isLessthan3 = true
            }
        }
    }
    @objc func updateCounter() {
        if circleView.timerSeconds > 0.01 {
            if isLessthan3 {
                circleView.pointingAngle = CGFloat(angle! - (angle! - CGFloat(Double.pi * 3/2)) * CGFloat(Double(1-circleView.timerSeconds/circleView.seconds)))
            } else {
                circleView.pointingAngle = CGFloat(angle! - (angle! + CGFloat(Double.pi/2)) * CGFloat(Double(1-circleView.timerSeconds/circleView.seconds)))
            }
            circleView.timerSeconds -= 0.01
         } else {
            timer.invalidate()
            button.setTitle("START", for: .normal)
            button.backgroundColor = UIColor(named: "DarkYellow")!
            view.backgroundColor = UIColor(named: "Grejfrut")!
            circleView.counterColor = UIColor(named: "LightGrejfrut")!
            circleView.outlineColor = UIColor(named: "Grejfrut")!
            circleView.gestureOpen = true
            circleView.timerSeconds = circleView.seconds
            circleView.isPointing = true
            if circleView.seconds > 3 {
                circleView.pointingAngle = CGFloat((circleView.timerSeconds-3) * Double.pi/6)
                isLessthan3 = false
            } else {
                circleView.pointingAngle = CGFloat(Double.pi * 2 - ((3-circleView.timerSeconds) * Double.pi/6))
                 isLessthan3 = true
            }
            blink()
        }
    }
    func blink() {
        UIView.animate(withDuration: 1.5, delay: 0.2, options: .transitionCrossDissolve, animations: {self.view.alpha = 0.0})
        UIView.animate(withDuration: 1.5, delay: 0.0, options: .transitionCrossDissolve, animations: {self.view.alpha = 1.0})
        }
}
