//
//  WecscrapeScript.swift
//  Cook Assistant
//
//  Created by Arata Michael Katayama on 2022/11/26.
//

import SwiftUI
import Firebase
import SwiftSoup

class RecipesList {
    var recipeArray = [Recipe]()
    
    init() {
        recipeArray = []
    }
    
    func push(name: String, description: String, image: String) {
        self.recipeArray.append(Recipe(name: name, description: description, image: image))
    }
}

class Recipe {
    
    var name: String
    var description: String
    var image: String
    // var ingredient: [String]
    // var nutrition: [String]
    
    init(name: String, description: String, image: String) {
        self.name = name
        self.description = description
        self.image = image
        // self.ingredient = ingredient
        // self.nutrition = nutrition
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
//    func getIngredient() -> [String] {
//        return self.ingredient
//    }
//    func getNutrition() -> [String] {
//        return self.nutrition
//    }
    
}

// function that extracts every recipe link from the main page of the website
func getRecipeUrls(baseUrl: String, linkClass: String) -> [String]? {  // n is the page number of baseurl
    
    var subUrlList: [String] = []
    
    // if baseUrl cannot be found or accessed
    guard let accessBaseUrl = URL(string: baseUrl) else {
        print("Invalid URL Error: \(baseUrl)")
        return nil // break from the function
    }
    
    // retrieve the html code for accessBaseUrl
    do {
        let baseHtmlString = try String(contentsOf: accessBaseUrl, encoding: .ascii)
        // parsing html and retrieving tags with desired title
        do {
            let doc: Document = try SwiftSoup.parse(baseHtmlString)
            // inserting every "a" tag into array sublink
            let allLinks: [Element] = try doc.select("a").array()
            for i in 0..<allLinks.count {
                let className: String = try allLinks[i].className()
                // className is susceptible to change
                if className == linkClass {
                    subUrlList.append(try "\(allLinks[i].attr("href"))")
                }
            }
            
        } catch Exception.Error(type: let type, Message: let message){
            print("Error: \(type), \(message)")
        }
    } catch let error {
        print(error)
    }
    
    return subUrlList
}

func populateRecipe(subUrlList: [String]?, nameID: String, infoID: String, imgID: String) -> [Recipe] {
    var recipes = RecipesList()
    
    // unwrap optional to see if it contains anything
    if let unwrapped = subUrlList {
        for subUrl in unwrapped {
            // if subUrl cannot be found or accessed
            guard let accessSubUrl = URL(string: subUrl) else {
                print("Invalid URL Error: \(subUrl)")
                return nil  // break from the function
            }
            do {
                let subHtmlString = try String(contentsOf: accessSubUrl, encoding: .ascii)
                // parsing html and retrieving tags with desired title
                do {
                    let doc: Document = try SwiftSoup.parse(subHtmlString)
                    // inserting every "a" tag into array sublink
                    var rNames: String = try doc.select("#\(nameID)").text()
                    var rInfo: String = try doc.select("#\(infoID)").text()
                    var rImage: String = try doc.select("#\(imgID)").attr("href")
                    recipes.push(name: rNames, description: rInfo, image: rImage)
                    
                } catch Exception.Error(type: let type, Message: let message){
                    print("Error: \(type), \(message)")
                }
            } catch let error {
                print(error)
            }
        }
    } else {
        return nil
    }
    
    return recipes
}


// id for name: article-heading_2-0
func scrapeData(subUrl: String, id: String){
    // if baseUrl cannot be found or accessed
    guard let accessSubUrl = URL(string: subUrl) else {
        print("Invalid URL Error: \(subUrl)")
        return // break from the function
    }
    // retrieve the html code for accessBaseUrl
    do {
        let recipeHtml = try String(contentsOf: accessSubUrl, encoding: .ascii)
        // parsing html and retrieving tags with desired title
        do {
            let doc: Document = try SwiftSoup.parse(recipeHtml)
            // inserting every "a" tag into array sublink
            let target = try doc.select("#\(id)").first()
            // if header tag then
            if target?.tagName() != "h1"{
                
            }
            
        } catch Exception.Error(type: let type, Message: let message){
            print("Error: \(type), \(message)")
        }
    } catch let error {
        print(error)
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
    
    
    var body: some View {
        
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button ("Hello, world!") {
                // build subUrlList
                for i in 0..<100 {
//                    getRecipeUrls(n: i)
                }
                // for each subUrl
                
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
