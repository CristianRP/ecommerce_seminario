# frozen_string_literal: true

ch = %w[Small
        Medium
        Large
        Blanca
        Rojo
        Negro
        Metal
        XL
        Fresa
        Menta]

ch.each do |c|
  Characteristic.create(name: c)
end
