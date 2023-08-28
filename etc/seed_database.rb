require "net/http"
require "json"

url = "https://raw.githubusercontent.com/eddydn/DictionaryDatabase/master/EDMTDictionary.json"
uri = URI(url)
response = Net::HTTP.get(uri)
json_dictionary = JSON.parse(response)

json_dictionary.each { |iword|
  if (iword["word"].length > 1)
    word = iword["word"]
    itype = iword["type"]
    definition = iword["description"]

    # puts "word is #{word}"

    part_of_speech = "v"
    if itype.start_with?("(n") || itype.start_with?("(pl.") || itype.start_with?("(interj.") || itype.start_with?("(pron.") || itype.end_with?("n.)")
      part_of_speech = "N"
    elsif itype == "(adv.)" || itype == "(adv)" || itype.start_with?("(adv")
      part_of_speech == "Adv"
    elsif itype.start_with?("(v")
      part_of_speech = "V"
    elsif itype.start_with? "(a." || itype.start_with?("(adj.)") || itype.start_with?("(Compar.")
      part_of_speech = "Adj"
    elsif itype.strip.start_with?("(supe")
      part_of_speech = "Adj"
    else
      puts "part of speech was #{itype}"
    end
  else
    # puts "Word is " + iword["word"]
  end
}
