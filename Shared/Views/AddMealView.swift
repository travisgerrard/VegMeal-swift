//
//  AddMealView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/9/20.
//

import SwiftUI
import Apollo
import SDWebImageSwiftUI

struct AddMealView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State var isCamera = false
    var isEditingMeal = false
    var url: URL? = nil
    var mealId = ""
    
    @State private var showingActionSheet = false
    
    @State private var inputImage: UIImage?
    @State var name = ""
    @State var description = ""
    @EnvironmentObject var user: UserStore
    @State var isUploadingImage = false
    @EnvironmentObject var networkingController: ApolloNetworkingController
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func addNewMeal() {
        if image != nil && name != "" && description != "" {
            self.networkingController.addNewMeal(authorId: user.userid, inputImage: inputImage!, name: name, description: description)
        } else {
            return
        }
    }
    
    func updateMeal() {
        if name != "" && description != "" {
            self.networkingController.updateMeal(mealId: mealId, name: name, description: description)
        } else {
            return
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(isEditingMeal ? "Edit \(name)" : "Add A New Meal").font(.title).padding()
                Spacer()
            }
            
            if isEditingMeal {
                WebImage(url: url!)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .overlay(
                        VStack{
                            HStack {
                                Text(name)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .minimumScaleFactor(0.5)
                                    .padding(.leading)
                                    .padding(.top)
                                    .padding(.bottom, 1)

                                Spacer()
                            }
                            HStack {
                                Text(description)
                                    .font(.subheadline)
                                    .padding(.leading)
                                    .padding(.bottom)
                                
                                Spacer()
                            }
                        }.background(BlurView(style: .systemMaterial))
                        , alignment: .bottom)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
            } else {
                if image != nil {
                    image!
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: screen.width - 60)
                        .frame(height: 300)
                        .overlay(
                            VStack{
                                HStack {
                                    Text(name)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .minimumScaleFactor(0.5)
                                        .padding(.leading)
                                        .padding(.top)
                                        .padding(.bottom, 1)
                                    
                                    Spacer()
                                }
                                HStack {
                                    Text(description)
                                        .font(.subheadline)
                                        .padding(.leading)
                                        .padding(.bottom)
                                    
                                    Spacer()
                                }
                            }.background(BlurView(style: .systemMaterial))
                            , alignment: .bottom)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                        .padding(.bottom, 30)
                } else {
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .overlay(
                            VStack{
                                HStack {
                                    Text(name)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .minimumScaleFactor(0.5)
                                        .padding(.leading)
                                        .padding(.top)
                                        .padding(.bottom, 1)
                                    
                                    Spacer()
                                }
                                HStack {
                                    Text(description)
                                        .font(.subheadline)
                                        .padding(.leading)
                                        .padding(.bottom)
                                    
                                    Spacer()
                                }
                            }.background(BlurView(style: .systemMaterial))
                            , alignment: .bottom)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                }
            }
            
            if isUploadingImage {
                Text("Uploading Image")
            }
            Spacer()
            
            if !isEditingMeal {
                HStack {
                    Button("Add photo", action: {
                        self.showingActionSheet = true
                    })
                    .padding()
                    .actionSheet(isPresented: $showingActionSheet) {
                        ActionSheet(title: Text("Add Photo"), message: Text("Add photo from:"), buttons: [
                            .default(Text("Camera")) {
                                self.isCamera = true
                                self.showingImagePicker = true
                            },
                            .default(Text("Photo Library")) {
                                self.isCamera = false
                                self.showingImagePicker = true
                                
                            },
                            .cancel()
                        ])
                    }
                    .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                        ImagePicker(image: self.$inputImage, isCamera: self.isCamera)
                    }
                    Spacer()
                }
            }
            
            
            VStack {
                TextField("Name", text: $name).padding(.horizontal)
                Divider().background(Color.black).padding(.horizontal)
                
                TextField("Description", text: $description).padding(.horizontal)
                Divider().background(Color.black).padding(.horizontal)
            }
            HStack{
                Spacer()
                Button("Submit", action: {
                    if isEditingMeal{
                        updateMeal()
                    } else {
                        addNewMeal()
                    }
                }).padding()
            }
            
            Spacer()
            
        }
    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var isCamera: Bool = false
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.presentationMode) var presentationMode
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        if UIImagePickerController.isSourceTypeAvailable(.camera) && isCamera {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImagePicker
    
    init(_ parent: ImagePicker) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let uiImage = info[.originalImage] as? UIImage {
            parent.image = uiImage
        }
        
        parent.presentationMode.wrappedValue.dismiss()
    }
}
