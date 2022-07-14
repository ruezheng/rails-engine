require 'rails_helper'

RSpec.describe 'Items API' do
  it "index action returns a list of all items for all merchants" do
    merchant1 = create(:merchant)
    create_list(:item, 20, merchant_id: merchant1.id)

    get "/api/v1/items"

    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]

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
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)

      expect(item).to_not have_key(:created_at)
      expect(item).to_not have_key(:updated_at)
    end
  end

  it "returns an empty array if no items exist" do
    get "/api/v1/items"

    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]

    expect(response).to be_successful
    expect(items.count).to eq(0)
    expect(items).to eq([])
  end

  it "show action returns one item" do
    merchant1 = create(:merchant)
    item1 = create(:item, merchant_id: merchant1.id)

    get "/api/v1/items/#{item1.id}"

    response_body = JSON.parse(response.body, symbolize_names: true)
    item = response_body[:data]

    expect(response).to be_successful
    expect(response.status).to eq(200)

    expect(item).to have_key(:id)
    expect(item[:id]).to be_a(String)

    expect(item).to have_key(:type)
    expect(item[:type]).to eq('item')

    expect(item).to have_key(:attributes)
    expect(item[:attributes][:name]).to be_a(String)
    expect(item[:attributes][:description]).to be_a(String)
    expect(item[:attributes][:unit_price]).to be_a(Float)
    expect(item[:attributes][:merchant_id]).to be_a(Integer)

    expect(item).to_not have_key(:created_at)
    expect(item).to_not have_key(:updated_at)
  end

  it "index action returns a list of a specific merchant's items" do
    merchant1 = create(:merchant)
    create_list(:item, 20, merchant_id: merchant1.id)

    get "/api/v1/merchants/#{merchant1.id}/items"

    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]

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
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)

      expect(item).to_not have_key(:created_at)
      expect(item).to_not have_key(:updated_at)
    end
  end

  it "creates a new item and ignores any additional attributes" do
    merchant1 = create(:merchant)
    item_params = {
      name: "Canon",
      description: "EOS 6D Mark II",
      unit_price: 1249.99,
      merchant_id: merchant1.id,
      weight: 3
      }

    headers = {"CONTENT_TYPE" => "application/json"}
    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful
    expect(response.status).to eq(201)

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "updates an item" do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    previous_name = Item.last.name
    item_params = { name: 'Nikon' }

    headers = {"CONTENT_TYPE" => "application/json"}
    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

    item = Item.find_by(id: item.id)

    expect(response).to be_successful
    expect(item.name).to eq(item_params[:name])
    expect(item.name).to_not eq(previous_name)
  end
end
