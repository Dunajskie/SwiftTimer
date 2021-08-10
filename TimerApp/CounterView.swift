//
//  CounterView.swift
//  TimerApp
//
//  Created by Michał Dunajski on 06/08/2021.
//

import UIKit

class CounterView: UIView {
    let timeLabel: UILabel = UILabel()
    let secLabel: UILabel = UILabel()
    let stackView: UIStackView = UIStackView()
    let startAngle: CGFloat = CGFloat(0)
    let endAngle: CGFloat = CGFloat(Double.pi * 2)
    let angle: CGFloat = CGFloat(Double.pi*3/2)
    let lineWidth: CGFloat = 5.0
    let arcWidth: CGFloat = 50
    var seconds = 1.0
    var gestureOpen = true
    var slider = UIBezierPath()
    var outlineColor: UIColor = UIColor(named: "Grejfrut")!
    var counterColor: UIColor = UIColor(named: "LightGrejfrut")!
    var sliderColor: UIColor = UIColor(named: "DarkYellow")!
    var radiusSize: CGFloat?
    var centerPoint: CGPoint?
    var isPointing = true
    var pointingAngle: CGFloat = CGFloat(Double.pi*3/2 + Double.pi/6) {
          didSet {
              setNeedsDisplay()
          }
      }
    var timerSeconds = 1.0 {
        didSet {
            var timerText = "01:00"
            timerText = labelText(num: timerSeconds)
            timeLabel.text = timerText
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
        fatalError("init(coder:) has not been implemented")
    }
    func setupConstrains() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 10).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 175).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -30).isActive = true
        timeLabel.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        secLabel.translatesAutoresizingMaskIntoConstraints = false
        secLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor).isActive = true
        secLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        secLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        secLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
    }
    func setupOptions() {
        timeLabel.text = "01:00"
        timeLabel.textAlignment = .right
        timeLabel.numberOfLines = 1
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textColor = .white
        timeLabel.font  = UIFont.monospacedDigitSystemFont(ofSize: 53.0, weight: UIFont.Weight.semibold)
        secLabel.text = "sec"
        secLabel.textColor = .white
        secLabel.textAlignment = .left
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.axis = .horizontal
    }
    func setupHierarchy() {
        self.addSubview(stackView)
        stackView.addSubview(timeLabel)
        stackView.addSubview(secLabel)
    }
  override func draw(_ rect: CGRect) {
    radiusSize = (bounds.width - CGFloat(14))/2
    centerPoint = CGPoint(x: (bounds.width) / 2, y: (bounds.height) / 2)

    let path = UIBezierPath(
      arcCenter: centerPoint!,
      radius: radiusSize! - arcWidth/2,
      startAngle: startAngle,
      endAngle: endAngle,
      clockwise: true)
    path.lineWidth = arcWidth
    counterColor.setStroke()
    path.stroke()
    slider = UIBezierPath(
        arcCenter: centerPoint!,
        radius: radiusSize! - arcWidth/2,
        startAngle: angle,
        endAngle: pointingAngle ,
        clockwise: true
        )
    sliderColor.setStroke()
    slider.lineWidth = 50
    slider.stroke()
    if isPointing {
    drawPointer()
    }
      for iter in 1...12 {
        let line = UIBezierPath()
        drawLine(context: line, center: centerPoint!, radius: radiusSize!, angle: CGFloat((Double(iter))*(.pi/6)))
      }
    }
    func drawLine(context: UIBezierPath, center: CGPoint, radius: CGFloat, angle: CGFloat) {
        context.move(to: CGPoint(x: centerPoint!.x + (radiusSize!-arcWidth+7) * cos(angle), y: centerPoint!.y - (radiusSize!-arcWidth+7) * sin(angle)))
        context.addLine(to: CGPoint(x: centerPoint!.x + (radiusSize!-7) * cos(angle), y: centerPoint!.y - (radiusSize!-7) * sin(angle)))
        context.lineWidth = 5.0
        outlineColor.setStroke()
        context.stroke()
    }
    func drawPointer() {
        let pointer = UIBezierPath()
        let size = radiusSize!-arcWidth-6
        pointer.move(to: CGPoint(x: centerPoint!.x + (size) * sin(pointingAngle+CGFloat(Double.pi/2)), y: centerPoint!.y - (size) * cos(pointingAngle+CGFloat(Double.pi/2))))
        pointer.addLine(to: CGPoint(x: centerPoint!.x + (radiusSize!+6) * sin(pointingAngle+CGFloat(Double.pi/2)), y: centerPoint!.y - (radiusSize!+6) * cos(pointingAngle+CGFloat(Double.pi/2))))
        pointer.lineWidth = 15.0
        sliderColor.setStroke()
        pointer.stroke()
    }
    func drawTimerLine(oldPath: UIBezierPath, andAngle: CGFloat) {
        let timerLine = UIBezierPath(
            arcCenter: centerPoint!,
            radius: radiusSize! - arcWidth/2,
            startAngle: angle,
            endAngle: pointingAngle ,
            clockwise: true
            )
        sliderColor.setStroke()
        timerLine.lineWidth = 50
        timerLine.stroke()
    }
    func labelText(num: Double) -> String {
        var number = num
        var text = ""
        number += 0.0001
        let convertedNumber = Int(round(number*100))-Int(floor(number))*100
        if Int(floor(number)) < 10 {
            if (convertedNumber) == 0 {
            text = "0"+String(Int(floor(number)))+":" + String(convertedNumber) + "0"
                if (convertedNumber) < 10 && (convertedNumber) > 0 {
                    text = "0"+String(Int(floor(number)))+":0" + String(convertedNumber) + "0"
                }
            } else {
            text = "0"+String(Int(floor(number)))+":" + String(convertedNumber)
                if (convertedNumber) < 10 && (convertedNumber) > 0 {
                    text = "0"+String(Int(floor(number)))+":0" + String(convertedNumber)
                }
            }
        } else {
            if (convertedNumber) == 0 {
            text = String(Int(floor(number)))+":" + String(convertedNumber) + "0"
                if (convertedNumber) < 10 && (convertedNumber) > 0 {
                    text = String(Int(floor(number)))+":0" + String(convertedNumber) + "0"
                }
            } else {
            text = String(Int(floor(number)))+":" + String(convertedNumber)
                if (convertedNumber) < 10 && (convertedNumber) > 0 {
                    text = String(Int(floor(number)))+":0" + String(convertedNumber)
                }
            }
        }
        return text
    }
    @objc private func handleGesture(_ gesture: RotationGestureRecognizer) {
      var angleGesture: CGFloat = pointingAngle
      var tim = 1.0
      var sec = 1.0
      if gestureOpen {
        if gesture.touchAngle > 0 {
            angleGesture = gesture.touchAngle
        } else {
            angleGesture =  CGFloat(Double.pi) + (CGFloat(Double.pi) + gesture.touchAngle)
        }
        if angleGesture > CGFloat(Double.pi * 3/2) && angleGesture < CGFloat(Double.pi * 3/2 + Double.pi/6) {
            angleGesture = CGFloat(Double.pi * 3/2 + Double.pi/6)
            tim = 1
            sec = 1
        } else if angleGesture > CGFloat(Double.pi * 3/2 + Double.pi/6) && angleGesture < CGFloat(Double.pi * 2) {
            angleGesture -=  angleGesture.remainder(dividingBy: (CGFloat(Double.pi)/6))
            tim = 3 * ((Double(angleGesture) - (Double.pi/2 * 3)) / (Double.pi/2))
            sec = 3 * ((Double(angleGesture) - (Double.pi/2 * 3)) / (Double.pi/2))
        } else if angleGesture > CGFloat(0) && angleGesture < CGFloat(Double.pi + Double.pi * 5/12) {
            angleGesture -=  angleGesture.remainder(dividingBy: (CGFloat(Double.pi)/6))
            tim = 3 + 9 * (Double(angleGesture)  / (Double.pi * 3/2))
            sec = 3 + 9 * (Double(angleGesture)  / (Double.pi * 3/2))
        } else if angleGesture > CGFloat(Double.pi + Double.pi * 5/12) && angleGesture <= CGFloat(Double.pi * 3/2) {
            angleGesture = CGFloat(Double.pi * 3/2 - 0.001)
            tim = 12
            sec = 12
        }
        if pointingAngle > CGFloat(Double.pi * 3/2) && angleGesture > CGFloat(0) && angleGesture < CGFloat(Double.pi * 3/2) {
        } else if pointingAngle < CGFloat(Double.pi * 3/2) && pointingAngle > CGFloat(Double.pi) && angleGesture > CGFloat(Double.pi * 3/2) && angleGesture > CGFloat(0) {
        } else {
            pointingAngle = angleGesture
            timerSeconds = tim
            seconds = sec
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
