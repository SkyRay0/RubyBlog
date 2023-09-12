class Article < ApplicationRecord
  belongs_to :user, optional: true
  has_rich_text :content
end
