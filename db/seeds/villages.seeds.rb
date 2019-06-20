# frozen_string_literal: true

require 'savon'

client = Savon.client(wsdl: 'http://wsqa.caexlogistics.com:1880/wsCAEXLogisticsSB/wsCAEXLogisticsSB.asmx?WSDL')
response = client.call(:obtener_listado_poblados,
                       message: { 'Autenticacion' =>
                        { 'Login' => 'WSCOMERCIALIZADORA', 
                          'Password' => '449079bd0fed25041b39edb59d2ab50e' } })
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
