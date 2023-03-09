//
//  AddBookView.swift
//  Bookworm
//
//  Created by Aymeric Pilaert on 08/03/2023.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = "Fantasy"
    @State private var review = ""
    @State private var showingFormAlert = false
    
    let genres = ["Fantasy", "Horror", "Kids", "Romance", "Thriller", "Mystery", "Poetry"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id:\.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                    
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        if title.isEmpty || author.isEmpty || genre.isEmpty {
                            showingFormAlert = true
                        } else {
                            let newBook = Book(context: moc)
                            newBook.id = UUID()
                            newBook.title = title
                            newBook.author = author
                            newBook.rating = Int16(rating)
                            newBook.genre = genre
                            newBook.review = review
                            newBook.date = Date.now
                            
                            try? moc.save()
                            dismiss()
                        }
                        
                       
                    }
                }
            }
            .navigationTitle("Add Book")
            .alert("Form incomplete", isPresented: $showingFormAlert) {
                Button("Ok", role: .cancel) {}
            }
        }
    }
    
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
