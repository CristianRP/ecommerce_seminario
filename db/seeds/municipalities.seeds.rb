# frozen_string_literal: true

require 'savon'

auth = Parameter.auth
client = Savon.client(wsdl: auth.find_by_description('WSDL').text_value, log: true)
response = client.call(:obtener_listado_municipios,
                       message: { 'Autenticacion' =>
                        { 'Login' => auth.find_by_description('LOGIN').text_value,
                          'Password' => auth.find_by_description('PASSWORD').text_value } })

if response.success?
  municipalities = response.body[:obtener_listado_municipios_response][:resultado_obtener_municipios][:listado_municipios][:municipio]
  municipalities.each do |municipality|
    m = Municipality.new
    m.cod = municipality[:codigo]
    m.name = municipality[:nombre]
    m.department_id = municipality[:codigo_depto]
    m.header_id = municipality[:codigo_cabecera]
    m.save
  end
end
