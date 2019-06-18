# frozen_string_literal: true

cars = ['Cargo Expreso', 'Mensajero']

cars.each do |c|
  Carrier.create(name: c)
end
