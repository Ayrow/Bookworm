//
//  DetailView.swift
//  Bookworm
//
//  Created by Aymeric Pilaert on 09/03/2023.
//

import SwiftUI

struct DetailView: View {
    let book: Book
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                ZStack(alignment: .bottomTrailing){
                    Image(book.genre ?? "Fantasy")
                        .resizable()
                        .scaledToFit()
                    
                    Text(book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                    
                }
                
                Text(dateRepresentation(for: book.date))
                    .font(.title3)
                    .padding()
                
                Text(book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(book.review ?? "No Review")
                    .padding()
                
                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)
                
            }
            .navigationTitle(book.title ?? "Unknown book")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Delete Book", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    deleteBook()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure?")
            }
            .toolbar {
                Button {
                    showingDeleteAlert = true
                } label: {
                    Label("Delete this book", systemImage: "trash")
                }
            }
            
        }
        
    }
    func deleteBook() {
        moc.delete(book)
        
        try? moc.save()
        dismiss()
    }
    
    func dateRepresentation(for date: Date?) -> String {
        guard let date = date else { return "Date Unavailable" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long // <-- this is what's missing
        return dateFormatter.string(from: date)
    }
}
