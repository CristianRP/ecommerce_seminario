# frozen_string_literal: true

require 'savon'

auth = Parameter.auth
client = Savon.client(wsdl: auth.find_by_description('WSDL').text_value, log: true)
response = client.call(:obtener_listado_poblados,
                       message: { 'Autenticacion' =>
                        { 'Login' => auth.find_by_description('LOGIN').text_value,
                          'Password' => auth.find_by_description('PASSWORD').text_value } })
if response.success?
  villages = response.body[:obtener_listado_poblados_response][:resultado_obtener_poblados][:listado_poblados][:poblado]
  villages.each do |village|
    v = Village.new
    v.cod = village[:codigo]
    v.name = village[:nombre]
    v.department_id = village[:codigo_depto]
    v.municipality_id = village[:codigo_municipio]
    v.save
  end
end
