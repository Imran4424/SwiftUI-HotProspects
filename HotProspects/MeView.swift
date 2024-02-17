//
//  MeView.swift
//  HotProspects
//
//  Created by Shah Md Imran Hossain on 17/2/24.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    @State private var name = "Anonymous"
    @State private var emailAddress = "anonymous@yopmail.com"
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("name", text: $name)
                        .textContentType(.name)
                        .font(.title)
                    
                    TextField("email address", text: $emailAddress)
                        .textContentType(.emailAddress)
                        .font(.title)
                }
                
                Image(uiImage: qrCode)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .contextMenu {
                        Button {
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: qrCode)
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                        }
                    }
                
                Form {
                    Text("Generated QR Codes updates automatically")
                        .multilineTextAlignment(.center)
                }
            }
            
            .navigationTitle("Your Code")
            .onAppear(perform: updateCode)
            .onChange(of: name) { oldValue, newValue in
                updateCode()
            }
            .onChange(of: emailAddress) { oldValue, newValue in
                updateCode()
            }
        }
    }
}

// MARK: - methods
extension MeView {
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

#Preview {
    MeView()
}
