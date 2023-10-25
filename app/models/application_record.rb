class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # connects_to database: { writing: :primary, reading: :primary_replica }

  connects_to database: { caching: :readyset }
end
