//
//  WecscrapeScript.swift
//  Cook Assistant
//
//  Created by Arata Michael Katayama on 2022/11/26.
//

import SwiftUI
import Firebase
import SwiftSoup

struct Webscrape {
    
}

class Recipe {
    
    var name: String
    var description: String
    var image: String
    var ingredient: [String]
    var nutrition: [String]
    
    init(name: String, description: String, image: String, ingredient: [String], nutrition: [String]) {
        self.name = name
        self.description = description
        self.image = image
        self.ingredient = ingredient
        self.nutrition = nutrition
    }
    
    // getters method
    func getName() -> String {
        return self.name
    }
    func getDescription() -> String {
        return self.description
    }
    func getImage() -> String {
        return self.image
    }
    func getIngredient() -> [String] {
        return self.ingredient
    }
    func getNutrition() -> [String] {
        return self.nutrition
    }
}

struct WebscrapeView: View {
    
    // creating global variables for necessary html tags
//    @State var basehtml = ""
//    @State var subhtml = ""
//
//    @State var recipeLinks: [String] = []
//
//    @State var recipeNames: [String] = []
//    @State var recipeImageLinks: [String] = []
//    @State var recipeDescs: [String] = []  // description info
//    @State var recipeNutDict: [String: [String]] = [:]  // nutrition info
//    @State var recipeIngredDict: [String: [String]] = [:]  // ingred info
    
    // linking to Firebase
//    func addToFirestore() {
//
//    //    accessSubURL()
//        var recipeData = getRecipeData()
//
//        // creating a constant for the database
//        let db = Firestore.firestore()
//
//        // loop through the number of links retrieved to create the correct number of documents
//        // add all information to firestore
//        for i in 0..<recipeData.rn.count {
//            db.collection("recipeData").addDocument(data: ["name": recipeData.rn[i], "info": recipeData.rd[i], "image": recipeData.ri[i]])
//        }
//
//    }
    
    // global variable prevents function calls inside another function
    // better time complexity
    @State var subUrlList: [String] = []
    
    // function that extracts every recipe link from the main page of the website
    func getSubUrls(n: Int) {  // n is the page number of baseurl
        
        // URL of each page in allrecipes.com
        let baseUrl = "https://www.allrecipes.com/recipes/1947/everyday-cooking/quick-and-easy/?page=\(n)"
        
        // if baseUrl cannot be found or accessed
        guard let accessBaseUrl = URL(string: baseUrl) else {
            print("Invalid URL Error: \(baseUrl)")
            return // break from the function
        }
        
        // retrieve the html code for accessBaseUrl
        do {
            let baseHtmlString = try String(contentsOf: accessBaseUrl, encoding: .ascii)
            // parsing html and retrieving tags with desired title
            do {
                var doc: Document = try SwiftSoup.parse(baseHtmlString)
                // inserting every "a" tag into array sublink
                var allLinks: [Element] = try doc.select("a").array()
                for i in 0..<allLinks.count {
                    let className: String = try allLinks[i].className()
                    // className is susceptible to change
                    if className == "comp mntl-card-list-items mntl-document-card mntl-card card card--no-image" {
                        subUrlList.append(try "\(allLinks[i].attr("href"))")
                    }
                }
                
            } catch Exception.Error(type: let type, Message: let message){
                print("Error: \(type), \(message)")
            }
        } catch let error {
            print(error)
        }
    }
    
//    func getRecipeData() -> (rn: [String], rd: [String], ri: [String]) {  // optional string
//
//        // declared outside to use less memory
//        var recipeNames: [String] = []
//        var recipeDescriptions: [String] = []
//        var recipeImages: [String] = []
//
//        // for each page access all suburls and retrieve recipe data
//        for n in 0..<3 {
//
//            for subUrl in self.subUrlList {
//
//            }
//
//
//
//            if let unwrapped = recipeLinks {  // if recipeLinks is not nil
//                for subUrl in unwrapped {  // subUrlList contains recipe links for 1 whole page
//                    // access each subURLs and handle error
//                    guard let accessSubUrl = URL(string: subUrl) else {
//                        print("Invalid URL Error: \(subUrl)")
//                        continue // skip iteration
//                    }
//
//                    // retrieve the html code for accessSubUrl
//                    do {
//                        let subHtmlString = try String(contentsOf: accessSubUrl, encoding: .ascii)
//                        do {
//                            let doc: Document = try SwiftSoup.parse(subHtmlString)
//                            // inserting every "h1" tag into array sublink
//                            let allHeader: [Element] = try doc.select("h1").array()
//                            // inserting every "p" tag into array sublink
//                            let allParagraphs: [Element] = try doc.select("p").array()
//                            // inserting every "div" tag into array sublink
//                            let allImages: [Element] = try doc.select("img").array()
//                            // extracting recipe title
//                            for i in 0..<allHeader.count {
//                                let classNameTitle: String = try allHeader[i].className()
//                                let classNameDescription: String = try allParagraphs[i].className()
//                                let classNameImage: String = try allImages[i].className()
//                                // className is susceptible to change
//                                if classNameTitle == "comp type--lion article-heading mntl-text-block" {
//                                    let rName: String = try allHeader[i].text()
//                                    recipeNames.append(rName)
//                                    print("Successful")
//                                }
//                                // className is susceptible to change
//                                if classNameDescription == "comp type--dog article-subheading" {
//                                    let rDescription: String = try allParagraphs[i].text()
//                                    recipeDescriptions.append(rDescription)
//                                    print("Successful")
//                                }
//                                // className is susceptible to change
//                                if classNameImage == "universal-image__image lazyloaded" {
//                                    let rImage: String = try allImages[i].attr("data-src")
//                                    recipeImages.append(rImage)
//                                    print("Successful")
//                                }
//                            }
//
//                        } catch Exception.Error(type: let type, Message: let message){
//                            print("Error: \(type), \(message)")
//                        }
//                    } catch let error {
//                        print(error)
//                    }
//                }
//            } else {
//                continue
//            }
//        }
//
//        return (recipeNames, recipeDescriptions, recipeImages)
//    }
    
    var body: some View {
        
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button ("Hello, world!") {
                // build subUrlList
                for i in 0..<100 {
                    getSubUrls(n: i)
                }
                // for each subUrl
                
                print(subUrlList)
            }
        }
        .padding()
    }
}

struct WebscrapeView_Previews: PreviewProvider {
    static var previews: some View {
        WebscrapeView()
    }
}
