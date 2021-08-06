//
//  CounterView.swift
//  TimerApp
//
//  Created by Michał Dunajski on 06/08/2021.
//

import UIKit

class CounterView: UIView {
    let lbl:UILabel = UILabel()
    let seclbl: UILabel = UILabel()
    let stackView: UIStackView = UIStackView()
    let startAngle: CGFloat = CGFloat(0)
    let endAngle: CGFloat = CGFloat(Double.pi * 2)
    let angle: CGFloat = CGFloat(Double.pi*3/2)
    let lineWidth: CGFloat = 5.0
    let arcWidth: CGFloat = 50
    var seconds = 1.0
    var gestureOpen = true
    var slider = UIBezierPath()
    var outlineColor: UIColor = UIColor.white
    var counterColor: UIColor = UIColor.lightGray
    var sliderColor: UIColor = UIColor.black
    var radius_size:CGFloat?
    var centerPoint:CGPoint?
    var ispointing = true
    var angleend: CGFloat = CGFloat(Double.pi*3/2 + Double.pi/6) {
          didSet{
              setNeedsDisplay()
          }
      }
    var timeseconds = 1.0{
        didSet{
            var ltext = "01:00"
            ltext = labeltext(num: timeseconds)
            lbl.text = ltext
        }
    }
  
    
   init() {
           super.init(frame: .zero)
           self.backgroundColor = .clear
           let gestureRecognizer = RotationGestureRecognizer(target: self, action: #selector(CounterView.handleGesture(_:)))
           addGestureRecognizer(gestureRecognizer)
           setupHierarchy()
           setupOptions()
           setupConstrains()
        }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
  
    func setupConstrains(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 175).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
     
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        lbl.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -30).isActive = true
        lbl.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        lbl.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
     
        seclbl.translatesAutoresizingMaskIntoConstraints = false
        seclbl.leadingAnchor.constraint(equalTo: lbl.trailingAnchor).isActive = true
        seclbl.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        seclbl.heightAnchor.constraint(equalToConstant: 80).isActive = true
        seclbl.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
         
    }
    
    func setupOptions(){
        lbl.text = "01:00"
        lbl.textAlignment = .right
        lbl.numberOfLines = 1
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = .white
        lbl.font  = UIFont.boldSystemFont(ofSize: 45.0)
        seclbl.text = "sec"
        seclbl.textColor = .white
        seclbl.textAlignment = .left
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.axis = .horizontal
    }
    
    func setupHierarchy(){
        
        self.addSubview(stackView)
        stackView.addSubview(lbl)
        stackView.addSubview(seclbl)
    }
    
    
  override func draw(_ rect: CGRect) {
    
    radius_size = (bounds.width - CGFloat(10))/2
    centerPoint = CGPoint(x: (bounds.width - CGFloat(5)) / 2, y: (bounds.height - CGFloat(5)) / 2)

    let path = UIBezierPath(
      arcCenter: centerPoint!,
      radius: radius_size! - arcWidth/2,
      startAngle: startAngle,
      endAngle: endAngle,
      clockwise: true)
    path.lineWidth = arcWidth
    counterColor.setStroke()
    path.stroke()
    
    slider = UIBezierPath(
        arcCenter: centerPoint!,
        radius: radius_size! - arcWidth/2,
        startAngle: angle,
        endAngle: angleend ,
        clockwise: true
        )
    sliderColor.setStroke()
    slider.lineWidth = 50
    slider.stroke()
  
    if ispointing{
    drawPointer()
    }
      for i in 1...12 {
        let line = UIBezierPath()
        drawLine(context: line, center: centerPoint!, radius: radius_size!, angle: CGFloat((Double(i))*(.pi/6)))
      }
    }
    
    func drawLine(context: UIBezierPath, center: CGPoint, radius: CGFloat, angle: CGFloat) {
        //context.move(to: center)
        context.move(to: CGPoint(x: centerPoint!.x + (radius_size!-arcWidth+7) * cos(angle), y: centerPoint!.y - (radius_size!-arcWidth+7) * sin(angle)))
        context.addLine(to: CGPoint(x: centerPoint!.x + (radius_size!-7) * cos(angle), y: centerPoint!.y - (radius_size!-7) * sin(angle)))
        context.lineWidth = 5.0
        outlineColor.setStroke()
        context.stroke()
    }
    
    func drawPointer(){
        let pointer = UIBezierPath()
        pointer.move(to: CGPoint(x: centerPoint!.x + (radius_size!-arcWidth-6) * sin(angleend+CGFloat(Double.pi/2)), y: centerPoint!.y - (radius_size!-arcWidth-6) * cos(angleend+CGFloat(Double.pi/2))))
        pointer.addLine(to: CGPoint(x: centerPoint!.x + (radius_size!+6) * sin(angleend+CGFloat(Double.pi/2)), y: centerPoint!.y - (radius_size!+6) * cos(angleend+CGFloat(Double.pi/2))))
        pointer.lineWidth = 15.0
        sliderColor.setStroke()
        pointer.stroke()
    }
    
    func drawTimerLine(oldPath: UIBezierPath, andAngle: CGFloat){
        let timerLine = UIBezierPath(
            arcCenter: centerPoint!,
            radius: radius_size! - arcWidth/2,
            startAngle: angle,
            endAngle: angleend ,
            clockwise: true
            )
        sliderColor.setStroke()
        timerLine.lineWidth = 50
        timerLine.stroke()
    }
    
    func labeltext(num: Double) -> String {
        var number = num
        var text = ""
        number = number + 0.0001
        if Int(floor(number)) < 10
        {
            if (Int(round(number*100))-Int(floor(number))*100) == 0
            {
            text = "0"+String(Int(floor(number)))+":" + String(Int(round(number*100))-Int(floor(number))*100) + "0"
                if (Int(round(number*100))-Int(floor(number))*100) < 10 && (Int(round(number*100))-Int(floor(number))*100) > 0{
                    text = "0"+String(Int(floor(number)))+":0" + String(Int(round(number*100))-Int(floor(number))*100) + "0"
                }
            }
            else
            {
            text = "0"+String(Int(floor(number)))+":" + String(Int(round(number*100))-Int(floor(number))*100)
                if (Int(round(number*100))-Int(floor(number))*100) < 10 && (Int(round(number*100))-Int(floor(number))*100) > 0 {
                    text = "0"+String(Int(floor(number)))+":0" + String(Int(round(number*100))-Int(floor(number))*100)
                }
            }
        }
        else
        {
            if (Int(round(number*100))-Int(floor(number))*100) == 0
            {
            text = String(Int(floor(number)))+":" + String(Int(round(number*100))-Int(floor(number))*100) + "0"
                if (Int(round(number*100))-Int(floor(number))*100) < 10 && (Int(round(number*100))-Int(floor(number))*100) > 0 {
                    text = String(Int(floor(number)))+":0" + String(Int(round(number*100))-Int(floor(number))*100) + "0"
                }
            }
            else{
            text = String(Int(floor(number)))+":" + String(Int(round(number*100))-Int(floor(number))*100)
                if (Int(round(number*100))-Int(floor(number))*100) < 10 && (Int(round(number*100))-Int(floor(number))*100) > 0 {
                    text = String(Int(floor(number)))+":0" + String(Int(round(number*100))-Int(floor(number))*100)
                }
            }
        }
        return text
    }
    
    
    
    
    @objc private func handleGesture(_ gesture: RotationGestureRecognizer) {
      if gestureOpen{
        if gesture.touchAngle > 0
        {
            angleend = gesture.touchAngle
        }
        else{
            angleend =  CGFloat(Double.pi) + (CGFloat(Double.pi) + gesture.touchAngle)
        }
        if angleend > CGFloat(Double.pi * 3/2) && angleend < CGFloat(Double.pi * 3/2 + Double.pi/6)
        {
            angleend = CGFloat(Double.pi * 3/2 + Double.pi/6)
            timeseconds = 1
            seconds = 1
        }
        else if angleend > CGFloat(Double.pi * 3/2 + Double.pi/6) && angleend < CGFloat(Double.pi * 2)
        {
            angleend = angleend - angleend.remainder(dividingBy: (CGFloat(Double.pi)/6))
            timeseconds = 3 * ((Double(angleend) - (Double.pi/2 * 3)) / (Double.pi/2))
            seconds = 3 * ((Double(angleend) - (Double.pi/2 * 3)) / (Double.pi/2))
        }
        else if angleend > CGFloat(0) && angleend < CGFloat(Double.pi + Double.pi * 5/12)
        {
            angleend = angleend - angleend.remainder(dividingBy: (CGFloat(Double.pi)/6))
            timeseconds = 3 + 9 * (Double(angleend)  / (Double.pi * 3/2))
            seconds = 3 + 9 * (Double(angleend)  / (Double.pi * 3/2))
        }
        else if angleend > CGFloat(Double.pi + Double.pi * 5/12) && angleend <= CGFloat(Double.pi * 3/2)
        {
            angleend = CGFloat(Double.pi * 3/2 - 0.001)
            timeseconds = 12
            seconds = 12
        }
        
      }
    }
    
    class RotationGestureRecognizer: UIPanGestureRecognizer {
        private(set) var touchAngle: CGFloat = 0
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
          super.touchesBegan(touches, with: event)
          updateAngle(with: touches)
        }

        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
          super.touchesMoved(touches, with: event)
          updateAngle(with: touches)
        }
        private func updateAngle(with touches: Set<UITouch>) {
          guard
            let touch = touches.first,
            let view = view
          else {
            return
          }
          let touchPoint = touch.location(in: view)
          touchAngle = angle(for: touchPoint, in: view)
        }

        private func angle(for point: CGPoint, in view: UIView) -> CGFloat {
          let centerOffset = CGPoint(x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
          return atan2(centerOffset.y, centerOffset.x)
        }
        override init(target: Any?, action: Selector?) {
          super.init(target: target, action: action)

          maximumNumberOfTouches = 1
          minimumNumberOfTouches = 1
        }
    }
    
    
  
    
}
