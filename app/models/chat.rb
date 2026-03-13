class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  has_many :messages
end
