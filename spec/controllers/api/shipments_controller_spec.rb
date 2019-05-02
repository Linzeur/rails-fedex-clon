require 'rails_helper'
require 'faker'

RSpec.describe Api::ShipmentsController, type: :controller do

  before do
    User.delete_all
    Sender.delete_all
    Shipment.delete_all

    Sender.create(
      store_name: Faker::Commerce.department,
      email: Faker::Internet.email,
      order_id: 123
    )
    @user1 = User.create(
      username: Faker::Name.unique.name,
      email: Faker::Internet.email,
      password: "123456",
      authentication_token: Devise.friendly_token[0, 30],
      city: Faker::Address.city,
      country: Faker::Address.country,
      address: Faker::Address.street_address,
      role: "regular",
    )
    @user2 = User.create(
      username: Faker::Name.unique.name,
      email: Faker::Internet.email,
      password: "123456",
      authentication_token: Devise.friendly_token[0, 30],
      city: Faker::Address.city,
      country: Faker::Address.country,
      address: Faker::Address.street_address,
      role: "regular",
    )
    @shipment1 = Shipment.create(
      tracking_id: Faker::Alphanumeric.alphanumeric(10),
      origin_address: Faker::Address.full_address,
      destination_address: Faker::Address.full_address, 
      weight: Faker::Number.between(1, 10),
      reception_date: Faker::Date.forward(60),
      estimated_delivery_date: Faker::Date.forward(60),
      freight_value: Faker::Number.between(20 ,100),
      user_id: @user1.id,
      sender_id: Sender.all.first.id
    )
    @shipment2 = Shipment.create(
      tracking_id: Faker::Alphanumeric.alphanumeric(10),
      origin_address: Faker::Address.full_address,
      destination_address: Faker::Address.full_address, 
      weight: Faker::Number.between(1, 10),
      reception_date: Faker::Date.forward(60),
      estimated_delivery_date: Faker::Date.forward(60),
      freight_value: Faker::Number.between(20 ,100),
      user_id: @user2.id,
      sender_id: Sender.all.first.id
    )
  end

  describe 'GET search' do
    it 'returns http status unathorized
        when you do not pass the token in header' do
      get :search
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http status bad request
        when you pass token but you do not pass parameter tracking_number' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :search
      expect(response).to have_http_status(:bad_request)
    end

    it 'render json with a specify error message
        when you pass token but you do not pass parameter tracking_number' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :search
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("You have to pass the argument 'tracking_number'")
    end

    it 'returns http status not found
        when you pass token and tracking_number but the last one do not exist' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :search, params: { tracking_number: "asdas78686" }
      expect(response).to have_http_status(:not_found)
    end

    it 'render json with a specify error message
        when you pass token and tracking_number but the last one do not exist' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :search, params: { tracking_number: "asdas78686" }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("It doesn't exists a shipment with that tracking number")
    end

    it 'returns http status ok' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :search, params: { tracking_number: @shipment1.tracking_id }
      expect(response).to have_http_status(:ok)
    end

    it 'render json with general attributes
        when you pass a tracking_number but it does not belong you' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :search, params: { tracking_number: @shipment2.tracking_id }
      expected_response = JSON.parse(response.body)
      expect(expected_response.keys).not_to include("recipient")
    end

    it 'render json with general and private attributes 
        when you pass a tracking_number and it belongs you' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      get :search, params: { tracking_number: @shipment2.tracking_id }
      expected_response = JSON.parse(response.body)
      expect(expected_response.keys).to include("recipient")
    end
  end

end