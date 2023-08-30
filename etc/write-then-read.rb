require "json"
require "rest-client"

post_url = "http://127.0.0.1:3000/api/words"

word_hash = {
  :word => "Z-Inveigle",
  :part_of_speech => "v",
  :definitions => [
    { :definition => "Persuade (someone) to do something by means of deception or flattery." },
  ],
}

json_post = word_hash.to_json
response = RestClient.post(post_url, json_post, { content_type: :json, accept: :json })
nw_id = JSON.parse(response.body)["id"]
response_2 = RestClient.get "http://localhost:3000/api/words/#{nw_id}"

puts response_2
