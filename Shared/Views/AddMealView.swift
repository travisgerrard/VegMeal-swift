//
//  AddMealView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/9/20.
//

import SwiftUI
import Apollo
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

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
    @State var isUploadingImage = false
    @EnvironmentObject var networkingController: ApolloNetworkingController
    @Binding var showModal: Bool
    
    @AppStorage("userid") var userid = ""
    
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func addNewMeal() {
        if image != nil && name != "" && description != "" {
            self.networkingController.addNewMeal(authorId: userid, inputImage: inputImage!, name: name, description: description)
        } else {
            return
        }
    }
    
    func updateMeal() {
        if name != "" && description != "" {
            if (image != nil) {
                self.networkingController.updateMealWithImage(mealId: mealId, name: name, description: description, inputImage: inputImage!)
            }
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
            
            if image != nil {
                image!
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 175)
                    .frame(height: 225)
                    .overlay(
                        OverLayText(name: name, description: description), alignment: .bottom)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                    .padding(.bottom, 20)
            } else if isEditingMeal {
                KFImage(url!,
                        options: [
                            .transition(.fade(0.2)),
                            .processor(
                                DownsamplingImageProcessor(size: CGSize(width: 400, height: 400))
                            ),
                            .cacheOriginalImage
                        ])
                    .placeholder {
                        HStack {
                            Image("009-eggplant")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding(10)
                            Text("Loading...").font(.title)
                        }
                        .foregroundColor(.gray)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 175)
                    .frame(height: 225)
                    .overlay(
                        OverLayText(name: name, description: description), alignment: .bottom)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
            } else {
                Rectangle()
                    .fill(Color.secondary)
                    .frame(maxWidth: 175)
                    .frame(height: 225)
                        OverLayText(name: name, description: description)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
            }
            
            
            if self.networkingController.isUploadingImage {
                Text("Uploading Image")
            }
            
            HStack {
                Button(isEditingMeal ? "Edit Photo" : "Add photo", action: {
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
            
            
            
            VStack {
                TextField("Name", text: $name).padding(.horizontal)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                Divider().background(Color.black).padding(.horizontal)
                
                TextField("Description", text: $description).padding(.horizontal)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                Divider().background(Color.black).padding(.horizontal)
            }
            HStack{
                Spacer()
                if self.networkingController.isUploadingImage {
                    ProgressView().onDisappear {
                        if self.networkingController.shouldCloseAddUpdateMealScreen {
                            self.showModal.toggle()
                        }
                    }
                }
                Button("Submit", action: {
                    if isEditingMeal{
                        updateMeal()
                    } else {
                        addNewMeal()
                    }
                }).padding().disabled(self.networkingController.isUploadingImage)
            }
            
            Spacer()
            
        }
    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(isEditingMeal: true, url: URL(string: "https://res.cloudinary.com/dehixvgdv/image/upload/v1601231238/veggily/5f70d984f115da6823f1bf9b.jpg"), showModal: .constant(true))
            .environmentObject(ApolloNetworkingController())
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

struct OverLayText: View {
    let name: String!
    let description: String!

    var body: some View {
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
        
    }
}
