//
//  AddMealCoreDataView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 1/22/21.
//

import SwiftUI
import Apollo
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

struct AddMealCoreDataView: View {
    var isEditingMeal: Bool = false
    
    @Binding var showModal: Bool
    
    var meal: MealDemo?
    
    @AppStorage("userid", store: UserDefaults.shared) var userid = ""
    
    
    
    var body: some View {
        if isEditingMeal {
            AddMealViewWithData(isEditingMeal: isEditingMeal, name: meal!.mealName, description: meal!.mealDetail, url: meal!.mealImageUrl, showModal: $showModal, meal: meal)
        } else {
            AddMealViewWithData(isEditingMeal: isEditingMeal, showModal: $showModal, meal: nil)
        }
    }
}

struct AddMealViewWithData: View {
    @EnvironmentObject var dataController: DataController

    let isEditingMeal: Bool
    @State var name: String = ""
    @State var description: String = ""
    @State var url: URL = URL(string: "")!
    @Binding var showModal: Bool
    
    let meal: MealDemo?
    
    // Stuff needed for camera
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State var isCamera = false
    @State private var showingActionSheet = false
    @State private var inputImage: UIImage?
    
    
    @AppStorage("userid", store: UserDefaults.shared) var userid = ""
    
    @State var isUploadingImage: Bool = false
    @State var shouldCloseAddUpdateMealScreen = false
    @State var uploadImageError: Error?
    
    @Environment(\.managedObjectContext) var managedObjectContext
    // Even though we wont be reading from this FetchRequest in this view you need it for the changes to be reflected immediately in your view.
    @FetchRequest(entity: MealDemo.entity(), sortDescriptors: []) var meals: FetchedResults<MealDemo>

    func addNewMeal() {
        if image != nil && name != "" && description != "" {
            print("Add meal, w/ image")
            
            self.uploadImageError = nil
            self.isUploadingImage = true
            
            let file = GraphQLFile(
                fieldName: "mealImage",
                originalName: name,
                mimeType: "image/jpeg",
                data: inputImage!.jpegData(compressionQuality: 0.5)!)
            
            
            let mutation = CreateMealMutation(authorId: userid, name: name, description: description, mealImage: name)
            ApolloController.shared.apollo.upload(operation: mutation, files: [file]) { result in
                self.isUploadingImage = false
                
                
                switch result {
                case .failure(let error):
                    self.uploadImageError = error
                    
                case .success(let graphQLResult):
                    //                print("Success: \(graphQLResult)")
                    guard let fragment = graphQLResult.data?.createMeal?.fragments.mealDemoFragment else { break }
                    
                    
                    _ = MealDemo.object(in: managedObjectContext, withFragment: fragment)
                    
                    self.shouldCloseAddUpdateMealScreen = true
                    
                    if let errors = graphQLResult.errors {
                        print("Errors: \(errors)")
                        let errorOne = errors[0]
                        print(errorOne)
                    }
                }
                
            }
        } else if name != "" && description != "" {
            print("Add meal, w/o image")
            self.isUploadingImage = true
            
            let mutation = CreateMealWithoutImageMutation(authorId: userid, name: name, description: description)
            ApolloController.shared.apollo.perform(mutation: mutation) { result in
                self.isUploadingImage = false
                
                switch result {
                case .failure(let error):
                    print(error)
                    self.uploadImageError = error
                    
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors {
                        print("Errors: \(errors)")
                        let errorOne = errors[0]
                        print(errorOne)
                        break
                    }
                    
                    print("Success: \(graphQLResult)")
                    guard let fragment = graphQLResult.data?.createMeal?.fragments.mealDemoFragment else { break }
                    
                    _ = MealDemo.object(in: managedObjectContext, withFragment: fragment)
                    self.shouldCloseAddUpdateMealScreen = true
                    self.shouldCloseAddUpdateMealScreen = true
                    
                    
                }
            }
        } else {
            return
        }
        try? managedObjectContext.save()
        dataController.save()

    }
    
    func updateMeal() {
        if name != "" && description != "" {
            // If there is an image to update
            if (image != nil) {
                self.uploadImageError = nil
                self.isUploadingImage = true
                
                let file = GraphQLFile(
                    fieldName: "mealImage",
                    originalName: name,
                    mimeType: "image/jpeg",
                    data: inputImage!.jpegData(compressionQuality: 0.5)!)
                
                let mutation = UpdateMealWithImageMutation(name: name, description: description, id: meal!.idString, mealImage: name)
                
                ApolloController.shared.apollo.upload(operation: mutation, files: [file]) { result in
                    self.isUploadingImage = false
                    
                    switch result {
                    case .failure(let error):
                        self.uploadImageError = error
                        
                    case .success(let graphQLResult):
                        guard let fragment = graphQLResult.data?.updateMeal?.fragments.mealDemoFragment else { break }
                        print(fragment)
                        meal!.name = name
                        meal!.detail = description
                        meal!.imageUrl = URL(string: fragment.mealImage!.publicUrlTransformed!)!
                        
                        self.shouldCloseAddUpdateMealScreen = true
                    }
                }
            } else {
                // No image to update
                let mutation = UpdateMealMutation(name: name, description: description, id: meal!.idString)
                self.isUploadingImage = true
                
                ApolloController.shared.apollo.perform(mutation: mutation) { result in
                    self.isUploadingImage = false
                    
                    switch result {
                    case .failure(let error):
                        self.uploadImageError = error
                        
                    case .success(let graphQLResult):
                        print(graphQLResult)
                        
                        meal!.name = name
                        meal!.detail = description
                        self.shouldCloseAddUpdateMealScreen = true
                    }
                }
            }
            
        } else {
            return
        }


    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
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
                KFImage(url,
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
                    .overlay(
                        OverLayText(name: name, description: description), alignment: .bottom)                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
            }
            
            
            if self.isUploadingImage {
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
                if self.isUploadingImage {
                    ProgressView().onDisappear {
                        if self.shouldCloseAddUpdateMealScreen {
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
                }).padding().disabled(self.isUploadingImage)
            }
            
            Spacer()
            
        }
    }
}

//struct AddMealCoreDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMealCoreDataView()
//    }
//}

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
