//
//  Classifier.swift
//  Runner
//
//  Created by Phat Tran on 16/11/2022.
//

import UIKit
import TensorFlowLite

class Classifier {
    
    private var interpreter: Interpreter
    init?() {
        guard let modelPath = Bundle.main.path(forResource: "model", ofType: "tflite")
        else {
            print("Failed to load the model!")
            return nil
        }
        
        do {
            interpreter = try Interpreter(modelPath: modelPath)
            
            try interpreter.allocateTensors()
            
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
    }
    
    func predict(frame pixelBuffer: CVPixelBuffer) -> (predictedDigit: Int?, probability: Float?) {
        let output: Tensor
        do {
            try interpreter.copy(pixelBuffer, toInputAt: 0)
            
            try interpreter.invoke()
            
            try output = interpreter.output(at: 0)
        } catch let error {
            print("\(error.localizedDescription)")
            return (nil, nil)
        }
        
        let results = (unsafeData: output.data)
        
        guard let maxProbability = results.max() else {return (nil, nil)}
        
        guard let predictedDigit = results.firstIndex(of: maxProbability) else {return (nil, nil)}
        
        return (predictedDigit, maxProbability)
    }
}
