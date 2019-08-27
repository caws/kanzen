class User < ApplicationRecord
  prepend Kanzen
  has_one :address
  has_many :cars
end