//
//  SearchBar.swift
//  VegMeal
//
//  Created by Travis Gerrard on 10/7/20.
//

import SwiftUI

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

struct SearchBar: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    @Binding var listIsLoading: Bool
    @Binding var shouldCloseView: Bool // Needed becuase in search view we don't want ending of editing to close the view. 
    var placeHolder: String


    var body: some View {
        VStack {
            HStack {
                TextField(placeHolder, text: $text, onEditingChanged: { edit in
                    if edit {
                        self.isEditing = true
                    } else {
                        self.isEditing = false
                    }
                },
                onCommit: {
                    self.isEditing = false
                })
                
                .padding(.leading, 32)
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
//                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                       
                        Spacer()
                        if listIsLoading {
                            ProgressView().padding(.trailing, 8)
                        }
                        if self.isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                



                if isEditing || shouldCloseView {
                    Button(action: {
                        self.shouldCloseView = false
                        self.isEditing = false
                        self.text = ""
                        // Dismiss the keyboard
                        hideKeyboard()
                    }) {
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
            Divider().background(Color.black).padding(.horizontal).padding(.vertical, 0)
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""), isEditing: .constant(true), listIsLoading: .constant(false), shouldCloseView: .constant(true), placeHolder: "Placeholder")
    }
}
