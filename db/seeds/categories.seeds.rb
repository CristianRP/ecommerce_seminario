# frozen_string_literal: true

cat = ['Cuidado Personal',
       'Electronicos',
       'Linea Blanca',
       'Muebles terraza y Jardin',
       'Ropa y accesorios']

cat.each do |c|
  Category.create(name: c)
end
