require "faker"
con = 1
5.times do
  Sender.create ([{
  store_name: Faker::Commerce.department,
  email: Faker::Internet.email,
  order_id: con 
  }])
  con += 1
end

5.times do
  User.create ([{
    username: Faker::Name.unique.name,       
    email: Faker::Internet.email,          
    password: "123456",
    city: Faker::Address.city,        
    country: Faker::Address.country,
    address: Faker::Address.street_address,  
    role: "regular"       
  }])
end
5.times do
  Shipment.create ([{
    tracking_id: Faker::Alphanumeric.alphanumeric(10),
    origin_adress: Faker::Address.full_address, 
    destination_address: Faker::Address.full_address, 
    weight: Faker::Number.between(1, 10),
    reception_date: Faker::Date.forward(60),
    estimated_delivery_date: Faker::Date.forward(60),
    freight_value: Faker::Number.between(20 ,100),
    user_id: User.all.reduce([]){ |array, val| array << val.id }.sample,
    sender_id: Sender.all.reduce([]){ |array, val| array << val.id }.sample
  }])
end
5.times do 
  ShipmentLocation.create ([{
    city: Faker::Address.city,
    country: Faker::Address.country,
    reception_date:Faker::Date.forward(20),
    shipment_id: Shipment.all.reduce([]){ |array, val| array << val.id }.sample,
  }])
end