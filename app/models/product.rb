class Product < ApplicationRecord
  belongs_to :brand
  belongs_to :category
  has_many :images, dependent: :destroy
  has_many :order_items, dependent: [:update, :destroy]
end
