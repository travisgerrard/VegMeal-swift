//
//  AddMealView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/9/20.
//

import SwiftUI
import Apollo

struct AddMealView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
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
        
//        let imageName = UUID().uuidString
        
        if image != nil && name != "" && description != "" {
//         
            self.networkingController.addNewMeal(authorId: user.userid, inputImage: inputImage!, name: name, description: description)
        } else {
            return
        }
        

    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Add A New Meal").font(.title).padding()
                Spacer()
            }
            if isUploadingImage {
                Text("Uploading Image")
            }
            Spacer()
            ZStack {
                
                
                if image != nil {
                    image?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                } else {
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(width: 250, height: 250, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                
            }
            .onTapGesture {
                self.showingImagePicker = true
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .padding()

            VStack {
                TextField("Name", text: $name).padding(.horizontal)
                Divider().background(Color.black).padding(.horizontal)

                TextField("Description", text: $description).padding(.horizontal)
                Divider().background(Color.black).padding(.horizontal)
            }
            HStack{
                Spacer()
                Button("Submit", action: {
                    addNewMeal()
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
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
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
