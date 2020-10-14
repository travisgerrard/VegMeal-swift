//
//  MealLog.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/23/20.
//

import SwiftUI

struct MealLogView: View {
    var mealId: String
    var authorId: String
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    @EnvironmentObject var mealLogController: MealLogApolloController
    
    var body: some View {
        VStack {
            HStack {
                Text("Meal Log")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                Spacer()
                Button("Made", action: {
                    withAnimation(.spring()) {
                        self.mealLogController.addMealLog(mealId: mealId, authorId: authorId)
                    }
                }).padding(.trailing)
            }
            ForEach(self.mealLogController.mealLogList) { mealLog in
                MealLog(id: mealLog.id, mealLogDate: dateFormatter.date(from: mealLog.dateMade!)!, thoughts: mealLog.thoughts ?? "Thoughts on meal and life?")
            }
            Spacer()
            
        }
        .onAppear {
            mealLogController.getMealLogList(mealId: mealId, authorId: authorId)
        }
    }
}

struct MealLog_Previews: PreviewProvider {
    static var previews: some View {
        MealLogView(mealId: "5f4c7bfdf818ca3c74eb7d6d", authorId: "5f4c7b0cf818ca3c74eb7d6b")
            .environmentObject(MealLogApolloController())
    }
}

struct MealLog: View {
    @EnvironmentObject var mealLogController: MealLogApolloController
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }   
    
    var id: String
    var placeholderString = "Thoughts on meal and life?"
    
    @State var mealLogDate: Date
    @State var isEditingMealLog = false
    @State var thoughts: String
    
    @State var mealLogDateDeafult = Date()
    @State var thoughtsDefault = ""
    
    var body: some View {
        if isEditingMealLog {
            VStack {
                HStack {
                    
                    DatePicker(selection: $mealLogDate, in: ...Date(), displayedComponents: .date) {
                        Text("You made this meal on:")
                    }
                    Spacer()
                }.padding()
                TextEditor(text: $thoughts)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .foregroundColor(self.thoughts == placeholderString ? .gray : .primary)
                    .onTapGesture {
                        if self.thoughts == placeholderString {
                            self.thoughts = ""
                        }
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                    .padding(.horizontal)
                
                
                Spacer()
                HStack {
                    Button("Save", action: {
                        withAnimation(.spring()) {
                            self.mealLogController.updateMealLog(id: id, thoughts: thoughts, dateMade: mealLogDate)
                            self.isEditingMealLog.toggle()
                        }
                    }).padding(.trailing)
                    Button("Cancel", action: {
                        withAnimation(.spring()) {
                            thoughts = thoughtsDefault
                            mealLogDate = mealLogDateDeafult
                            self.isEditingMealLog.toggle()
                        }
                    }).padding(.trailing)
                    Button("Delete", action: {
                        withAnimation(.spring()) {
                            self.mealLogController.deleteMealLog(id: id)
                            self.isEditingMealLog.toggle()
                        }
                    }).foregroundColor(.red)
                    
                    
                    Spacer()
                }.padding()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .background(BlurView(style: .systemMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
            .onAppear {
                thoughtsDefault = thoughts
                mealLogDateDeafult = mealLogDate
            }
            
        } else {
            VStack {
                HStack {
                    Text("You made this meal on: \(dateFormatter.string(from: mealLogDate))")
                    Spacer()
                }
                if thoughts.count > 0 && thoughts != "Thoughts on meal and life?" {
                    VStack {
                        HStack {
                            Button("Edit Comment", action: {
                                withAnimation(.spring()) {
                                    self.isEditingMealLog.toggle()
                                }
                            })
                            Spacer()
                        }
                        VStack {
                            HStack {
                                Text(thoughts)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.leading)
                                Spacer()
                                
                            }
                            //                            .frame(height: 100)
                            .padding()
                            .background(BlurView(style: .systemMaterial))
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                            
                            
                            Spacer()
                        }
                        .padding(.top, 5)
                    }
                } else {
                    HStack {
                        Button("Write a Comment", action: {
                            withAnimation(.spring()) {
                                self.isEditingMealLog.toggle()
                            }
                        })
                        
                        
                        Spacer()
                    }
                    
                }
            }.padding()
            
        }
        
    }
}
