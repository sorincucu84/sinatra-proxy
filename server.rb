require 'sinatra'
require 'open-uri'
require 'yaml'

$config = YAML.load_file('config.yml')

$config['mapping'].each do |mapping|

  puts "mapping #{mapping['method'].upcase} #{mapping['path']} -> #{mapping['host']}"
  send(mapping['method'].to_sym, "#{mapping['path']}/*") do
    path = "#{mapping['host']}/#{request.path.gsub(mapping['path'],'')}"
    #build http party url
    response = if (mapping['medthod'].downcase == 'get')
      HTTParty.get(path, query: params, headers: headers)
    else
      HTTParty.post(path, body: request.body, headers: headers)
    end
    status response.code
    response.body
  end
end