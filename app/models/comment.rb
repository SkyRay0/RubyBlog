class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :article, optional: true
  has_rich_text :content
end
