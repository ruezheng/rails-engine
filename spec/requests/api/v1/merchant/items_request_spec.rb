require 'rails_helper'

RSpec.describe 'Merchant Items API' do
  it "sends a list of items" do
    merchant1 = create(:merchant)
    create_list(:item, 20, merchant_id: merchant1.id)

    get "/api/v1/merchants/#{merchant1.id}/items"

    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]

    require "pry"; binding.pry
    expect(response).to be_successful
    expect(items.count).to eq(20)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item).to have_key(:type)
      expect(item[:type]).to eq('item')

      expect(item).to have_key(:attributes)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Integer)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)

      expect(item).to_not have_key(:created_at)
      expect(item).to_not have_key(:updated_at)
    end
  end
end
