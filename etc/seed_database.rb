require "json"
require "rest-client"

url = "https://raw.githubusercontent.com/eddydn/DictionaryDatabase/master/EDMTDictionary.json"
post_url = "http://127.0.0.1:3000/api/words"
response = RestClient.get url
json_dictionary = JSON.parse(response.body)

debug = false
count = 0

json_dictionary.each { |iword|
  if (iword["word"].length > 1)
    word = iword["word"]
    itype = iword["type"]
    definition = iword["description"]

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
      #   puts "part of speech was #{itype}"
    end

    word_hash = {
      :word => word,
      :part_of_speech => part_of_speech,
      :definitions => [
        { :definition => definition },
      ],
    }

    json_post = word_hash.to_json

    # if debug && count == 0
    puts "Posting #{json_post}"
    RestClient.post(post_url, json_post, { content_type: :json, accept: :json })
    #   count = count + 1
    # end
  else
    # puts "Word is " + iword["word"]
  end
}
