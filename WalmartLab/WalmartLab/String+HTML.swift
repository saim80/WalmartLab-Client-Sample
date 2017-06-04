//
//  String+HTML.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/30/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation

extension String {
    // Returns string by replacing all the occurrences of "key" with "value in a given dictionary.
    func replacingOccurrences(inDictionary dictionary:[String:String]) -> String {
        var newString = self
        for (key, value) in dictionary {
            newString = newString.replacingOccurrences(of: key, with: value)
        }
        return newString
    }

    func replacingOccurrencesOfASCIICodes() -> String {
        var outString = self

        if let regex = try? NSRegularExpression(pattern: "\\&\\#[0-9]{1,3}\\;", options: []) {
            while let match = regex.firstMatch(in: outString, options: [], range: NSRange(location:0, length:outString.characters.count)) {
                let startIndex = outString.index(outString.startIndex, offsetBy: match.range.location)
                let endIndex = outString.index(startIndex, offsetBy: match.range.length)
                let replacementRange = startIndex ..< endIndex
                let asciiCode = outString.substring(with: replacementRange).trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

                if let asciiNum = Int(asciiCode), let uncode = UnicodeScalar(asciiNum) {
                    let stringValue = String(uncode)
   
                    outString.replaceSubrange(replacementRange, with: stringValue)
                }
            }
        }

        return outString
    }

    // Returns string after undoing HTML safe escapes.
    var unescapedHTML : String {
        // XXX: the following mapping is incomplete. This project doesn't need the whole list.
        let char_dictionary = [
            "&quot;": "\"",
            "&apos;": "'",
            "&nbsp;" : " ",
            "&rsquo;" : "’",
            "&lsquo;" : "‘",
            "&trade;" : "™",
            "&ldquo;" : "“",
            "&rdquo;" : "”",
            "&reg;" : "®",
            "&cent;" : "¢",
            "&pound;" : "£",
            "&sect;" : "§",
            "&copy;" : "©",
            "&laquo;" : "«",
            "&raquo;" : "»",
            "&deg;" : "°",
            "&plusmn;" : "±",
            "&para;" : "¶",
            "&middot;" : "·",
            "&frac12;" : "½",
            "&ndash;" : "–",
            "&mdash;" : "—",
            "&sbquo;" : "‚",
            "&bdquo;" : "„",
            "&dagger;" : "†",
            "&Dagger;" : "‡",
            "&bull;" : "•",
            "&prime;" : "′",
            "&Prime;" : "″",
            "&euro;" : "€",
            "&asymp;" : "≈",
            "&ne;" : "≠",
            "&le;" : "≤",
            "&ge;" : "≥",
            "&lt;" : "<",
            "&gt;" : ">"
        ]
        var outResult = replacingOccurrences(inDictionary: char_dictionary)

        outResult = outResult.replacingOccurrencesOfASCIICodes()

        return outResult.replacingOccurrences(of: "&amp;", with: "&")
    }

    // Returns string after escaping html tag characters.
    var escapedHTML : String {
        // XXX: the following mapping is incomplete. This project doesn't need the whole list.
        let char_dictionary = [
            "<" : "&lt;",
            ">" : "&gt;",
            "\"" : "&quot;",
            "'" : "&apos;",
            "’" : "&rsquo;",
             "™" : "&trade;",
            "\"" : "&rdquo;",
            "®" : "&reg;"
        ];
        let outResult = replacingOccurrences(of: "&", with:"&amp;")

        return outResult.replacingOccurrences(inDictionary:char_dictionary)
    }

    // Returns string after deleting all the HTML tag occurrences in the current string.
    var stripHTML : String {
        var newString = self

        while let range = newString.range(of: "<[^>]+>", options: .regularExpression, range: newString.startIndex ..< newString.endIndex, locale: nil) {

            newString = newString.replacingCharacters(in: range, with: "")
        }
        
        return newString
    }
}
