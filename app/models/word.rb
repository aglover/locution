class Word < ApplicationRecord

    has_many :definitions

    validates :word, presence: true
    validates :part_of_speech, presence: true, length: { minimum: 1 }
end
