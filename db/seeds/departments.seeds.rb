# frozen_string_literal: true

require 'savon'

auth = Parameter.auth
client = Savon.client(wsdl: auth.find_by_description('WSDL').text_value, log: true)
response = client.call(:obtener_listado_departamentos,
                       message: { 'Autenticacion' =>
                        { 'Login' => auth.find_by_description('LOGIN').text_value,
                          'Password' => auth.find_by_description('PASSWORD').text_value } })

if response.success?
  departments = response.body[:obtener_listado_departamentos_response][:resultado_obtener_departamentos][:listado_departamentos][:departamento]
  departments.each do |department|
    d = Department.new
    d.cod = department[:codigo]
    d.name = department[:nombre]
    d.save
  end
end
