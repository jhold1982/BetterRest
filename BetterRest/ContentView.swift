//
//  ContentView.swift
//  BetterRest
//
//  Created by Justin Hold on 8/14/22.
//
import CoreML
import SwiftUI

struct ContentView: View {
	
	@State private var wakeUp = ContentView.defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
	@State private var resetSettings = true
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var sleepResults: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(
				wake: Double(hour + minute),
				estimatedSleep: sleepAmount,
				coffee: Double(coffeeAmount)
			)
            let sleepTime = wakeUp - prediction.actualSleep
            return "Your ideal bedtime is " + sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "There was an error."
        }
    }
	
	var coffeeFunFacts = [
		"Coffee has been around since 800 A.D.",
		"Technically, coffee beans are seeds.",
		"Brazil is the world's largest coffee producer.",
		"The most expensive coffee in the world can cost more than $600 per pound!",
		"Several people have attempted to outlaw coffee.",
		"Finland drinks the most coffee in the world.",
		"Coffee drinkers live longer than non-coffee users!",
		"Caffeine-free does not mean decaf.",
		"Norwegians drinks on an average 5 cups a day."
	]
    
    var body: some View {
		
        NavigationStack {
			
            Form {
                
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section("How much sleep do you want?") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily coffee intake") {
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1..<11) {
                            Text(String($0))
                        }
                    }
                }
                
                Text(sleepResults)
                    .font(.title3)
				
				Section("Fun facts about coffee!") {
					let randomFacts = coffeeFunFacts.randomElement()
					Text(randomFacts!)
				}
            }
            .navigationTitle("BetterRest")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						reset()
					} label: {
						Label("Reset", systemImage: "mug.fill")
					}
					.padding()
				}
			}
        }
    }
	
	
	
	
	
	func reset() {
		wakeUp = ContentView.defaultWakeTime
		sleepAmount = 8.0
		coffeeAmount = 1
		
	}
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
