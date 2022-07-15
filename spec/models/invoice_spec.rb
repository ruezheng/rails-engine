require 'rails_helper'

RSpec.describe Invoice do
  it { should have_many :invoice_items }
  it { should have_many(:items).through(:invoice_items) }
end
