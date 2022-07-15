require 'rails_helper'

RSpec.describe 'Merchants API' do
  it "index action returns a list of all merchants" do
    create_list(:merchant, 10)

    get '/api/v1/merchants'

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchants = response_body[:data]

    expect(response).to be_successful
    expect(merchants.count).to eq(10)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq('merchant')

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes][:name]).to be_a(String)

      expect(merchant).to_not have_key(:created_at)
      expect(merchant).to_not have_key(:updated_at)
    end
  end

  it "show action returns one merchant's data" do
    merchant1 = create(:merchant)

    get "/api/v1/merchants/#{merchant1.id}"

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]

    expect(response).to be_successful
    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq("#{merchant1.id}")

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq('merchant')

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes][:name]).to eq("#{merchant1.name}")

    expect(merchant).to_not have_key(:created_at)
    expect(merchant).to_not have_key(:updated_at)
  end

  it "returns 404 error if id is invalid" do
    get '/api/v1/mercahnts/10000'

    expect(response.status).to eq(404)
  end
end
