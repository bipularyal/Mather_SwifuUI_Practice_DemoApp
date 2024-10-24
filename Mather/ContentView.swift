//
//  ContentView.swift
//  Mather
//
//  Created by Bipul Aryal on 10/23/24.
//

//Goal: Create an edutainlment app to help kids learn methamatics.
/*
    Player needs to select wp to which multiplication table they want
    Player needs to select how many questions they want
    A button when pressed should generate that many questions as they asked for
    Time: 2.5 hours. By tonight end
    
    What to do?
            Welcome to the multiplier. Learn multiplication by doing.
            A form 3 things ... and a button kindof like submit.
            On click ... generate X questions between 2-12 and also from 1-10
            Show the following questions on screen.
            Something like 5 * 10 = and a place to answer.
            and user can submit.
            Once submitted, show how many they got correct and how many wrong. Also a cross button to go back ... it;d be good if we could do this in a different page ... or show hide different things based on where the user is ...
 
        
 */

import SwiftUI

struct ContentView: View {
    @State var formMode = true
    @State var questionMode = false
    @State var difficultyLevel: Int = 2
    @State var noOfQuestions: Int = 5
    var body: some View {
        if formMode {
            VStack {
                MatherForm(generateQuestions: {difficulty, questions in
                    difficultyLevel = difficulty
                    noOfQuestions = questions
                    formMode = false
                    questionMode = true
                })

            }
            .padding()
        } else if questionMode {
            MultiplierTable(noOfQuestions: noOfQuestions, difficultyLevel: difficultyLevel, goBack: {
                formMode = true
                questionMode = false
            }).padding()
        }
    }
}

struct MultiplierTable:View{
    @State var noOfQuestions: Int
    @State var difficultyLevel: Int
    @State var questions: Array<Question> = []
    @State var correctAnswersMode = false
    @State var correctAnswerCount: Int = 0
    @State var userAnswers: Array<String> = []
    var goBack: () -> Void
    
    var body: some View{
        VStack{
            Form{
                List{
                    ForEach(questions.indices, id:\.self){ index in
                        HStack{
                            Text("\(questions[index].mainVariable) * \(questions[index].multiplier) =")
                            TextField("", text: $userAnswers[index]).keyboardType(.numberPad)
                        }
                        .padding()
                        .background(correctAnswersMode ? questions[index].answer == Int(userAnswers[index]) ? .green:.red : .clear)
                    }
                }
            }
            HStack{
                Button(action: {checkAnswer()}){
                    Text("Check Answers")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Spacer()
                Button(action: {
                    
                    goBack()}){
                    Text("Go Back")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Spacer ()
            }
        }
        .onAppear {
                    generateQuestions()  // Generate questions when the view appears
            }
    }
    
    func generateQuestions(){
        for _ in 0..<noOfQuestions{
            let mainVariable = Int.random(in: 1...difficultyLevel)
            let multiplier  = Int.random(in: 0...12)
            questions.append(Question(mainVariable: mainVariable, multiplier: multiplier, answer: mainVariable*multiplier))
            userAnswers.append("")
        }
    }
                   
    
    
    func checkAnswer(){
        correctAnswersMode = true
    }
}

struct Question{
    let mainVariable: Int
    let multiplier: Int
    let answer: Int
}

struct MatherForm: View{
    var generateQuestions: (Int, Int) -> Void
    @State var difficultyLevel: Int = 2
    @State var noOfQuestions: Int = 5
    let possibleNoOfQuestions = [5,10,15,20]
    var body: some View{
        VStack{
            Form{
                Stepper(value: $difficultyLevel, in: 2...12){
                        Text("Select difficulty level.")
                            .font(.headline)
                        Text("\(difficultyLevel)")
                    
                }.padding(.bottom)
                
                Picker("Select how many questions do you want", selection: $noOfQuestions){
                    ForEach(possibleNoOfQuestions, id: \.self) {
                        Text("\($0)")
                    }
                }.pickerStyle(SegmentedPickerStyle()).padding(.bottom)
                
                Button(action: {
                    // Notify parent via closure
                    generateQuestions(difficultyLevel, noOfQuestions)
                }) {
                    Text("Get Questions")
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
