class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item
  has_many :discounts, through: :merchants
  has_many :customers, through: :invoice
  has_many :transactions, through: :invoice
end
