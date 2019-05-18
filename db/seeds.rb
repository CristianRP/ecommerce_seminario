# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Parameter.create(tag: 'TRANSACTION_TYPE',
                 description: 'Identificar el tipo de la transaccion.',
                 int_value: 1, text_value: 'ENTRADA')
Parameter.create(tag: 'TRANSACTION_TYPE',
                 description: 'Identificar el tipo de la transaccion.',
                 int_value: 1, text_value: 'ENTRADA')
