require "ondotori-ruby-client"

WEB_STORAGE_ACCESS_INFO_PATH = "/var/tmp/webstorage.json"
=begin
The webstorage.json looks like the following.
{
    "api-key":"T&D WebStorage API Key",
    "login-id" : "rbacxxxx",
    "login-pass" : "password"
}
=end

def load_params
  begin
    File.open(WEB_STORAGE_ACCESS_INFO_PATH) do |file|
      storage_info = file.read
      load_info = JSON.parse(storage_info)

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
end

def main
  unless params = load_params
    puts "Load parameter error..."
  end

  begin
    client = Ondotori::WebAPI::Client.new(params)
    response = client.current()
    puts "#{response}"
  rescue Ondotori::WebAPI::Api::Errors::Error => e
    puts "Some error happend #{e.message} #{e.code}"
  end
end

main

