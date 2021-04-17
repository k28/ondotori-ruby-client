# frozen_string_literal: true
require "ondotori-ruby-client"

WEB_STORAGE_ACCESS_INFO_PATH = "/var/tmp/webstorage.json"
# The webstorage.json looks like the following.
# {
#     "api-key":"T&D WebStorage API Key",
#     "login-id" : "rbacxxxx",
#     "login-pass" : "password"
# }

# Reads the information for API access from the file.
def load_params
  File.open(WEB_STORAGE_ACCESS_INFO_PATH) do |file|
    storage_info = file.read
    load_info = JSON.parse(storage_info)

    # This is not necessary, but is left for the explanation of the parameter settings.
    wss_access_info = {}
    wss_access_info["api-key"]    = load_info["api-key"]
    wss_access_info["login-id"]   = load_info["login-id"]
    wss_access_info["login-pass"] = load_info["login-pass"]
    return wss_access_info
  end
rescue SystemCallError => e
  puts %(class=[#{e.class}] message=[#{e.message}])
rescue IOError => e
  puts %(class=[#{e.class}] message=[#{e.message}])
end

def main
  params = load_params
  if params.nil?
    puts "Load parameter error..."
    return
  end

  %w[api-key login-id login-pass].each do |k|
    if params[k].nil?
      puts "parameter #{k} is nil. Please check #{WEB_STORAGE_ACCESS_INFO_PATH}"
      exit
    end
  end

  begin
    client = Ondotori::WebAPI::Client.new(params)
    response = client.current
    puts "#{response}"
  rescue Ondotori::WebAPI::Api::Errors::Error => e
    puts "Some error happend #{e.message} #{e.code}"
  end
end

main
