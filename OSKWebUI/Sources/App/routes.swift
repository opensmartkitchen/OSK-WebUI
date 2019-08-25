import Vapor
import OskGadgetCWrapMock

/// - Returns: seconds since 1970.01.01 00:00:00 UTC
func getUnixEpochSeconds(date dateString: String) -> Int64? {
    var formatStr = "yyyyMMddHHmmss"
    let dateFormatter = DateFormatter()
    if dateString.suffix(1) == "z" {
        formatStr.append("'z'")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    } 
    dateFormatter.dateFormat = formatStr
    if let date = dateFormatter.date(from: dateString) {
        return Int64(date.timeIntervalSince1970)
    }
    else {
        return nil
    }
}

/// - Parameters: 
///     - unixepoch: Unix Epoch seconds
///     - format: `FormatType`. default = `.filename` "yyyyMMdd_HHmmss"
///     - utc: Bool (note default `false` removed)
/// - Returns: formatted UTC date time `String`
func getDateTimeString(unixepoch: Int, utc: Bool = false) -> String {
    // Note: NSTimeInteral is Double
    let date = Date(timeIntervalSince1970: Double(unixepoch))
    let dateFormatter = DateFormatter()
    var formatStr = "yyyyMMddHHmmss"
    if utc {
        formatStr.append("'z'")
    }
    dateFormatter.dateFormat = formatStr        
    if utc {
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    }
    return dateFormatter.string(from: date)
}

func getDateTimeHumanString(unixepoch: Int, utc: Bool = false) -> String {
    // Note: NSTimeInteral is Double
    let date = Date(timeIntervalSince1970: Double(unixepoch))
    let dateFormatter = DateFormatter()
    var formatStr = "yyyy-MM-dd HH:mm:ss"
    if utc {
        formatStr.append("'z'")
    }
    dateFormatter.dateFormat = formatStr        
    if utc {
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    }
    return dateFormatter.string(from: date)
}


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // GET / home page
    router.get { req in
        return try req.view().render("home")
    }
    
    // GET /fruitbasket
    router.get("fruitbasket") { req -> Future<View> in
        let timestamp = oskGadgetGetLastTimestamp(oskGadget)
        let timestampStr = getDateTimeString(unixepoch: timestamp) 
        let timestampHumanStr = getDateTimeHumanString(unixepoch: timestamp) 
        
        // Create a FileManager instance
        let weightUrl = oskDataUrl.appendingPathComponent("\(timestampStr)_weight.csv", isDirectory: false)
        print("---")
        print(weightUrl.path)
        print("oskdata/\(timestampStr)_image.png")
        print("---")
        
        var weightStr = "unavailable"
        var rawDataStr = "scale data unavailable"
        if let s = try? String(contentsOf: weightUrl, encoding: .utf8) {
            rawDataStr = s.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            var parts = s.components(separatedBy: ",")
            parts = parts.dropLast()
            if parts.count >= 11 {
                weightStr = parts[10]
                // weightStr = String(format:"%.2f", Float(weight))
            }
            rawDataStr = parts.joined(separator: ", ")
        }
        
        
        return try req.view().render(
            "fruitbasket",
            [
                "oskPageWeight": weightStr,
                "oskPageTimestamp": timestampHumanStr,
                "oskPageImage": "osk/\(timestampStr)_image.png",   
                "oskPageRawData": rawDataStr + " :: " + timestampStr,   
            ]
        )
    }
    
    // GET /fruitbasket/STRING
    router.get("fruitbasket", String.parameter) { req -> Future<View> in
        return try req.view().render("fruitbasket", [
            "name": req.parameters.next(String.self)
            ])
    }
    
    // POST /fruitbasket
    router.post("fruitbasket", String.parameter) { req -> Future<View> in
        
        return try req.view().render("fruitbasket", [
            "name": req.parameters.next(String.self)
            ])
    }
    
    // GET /settings
    router.get("settings") { req -> Future<View> in
        return try req.view().render("settings")
    }
    
    
    
}
