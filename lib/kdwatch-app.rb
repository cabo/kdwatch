require_relative "kdwatch/version"
require 'bundler'
require 'tempfile'

# Bundler.require
require "bundler"
require "thin"
# require "guard-livereload"
require "rack-livereload"
require "guard"
require "sinatra"
require "kramdown-rfc2629"
ENV["KDRFC_PREPEND"] = "time" if system("time", "true", err: "/dev/null")
require "kramdown-rfc/kdrfc-processor"
require "net/http/persistent"

host = ENV["KDWATCH_HOST"]
port = ENV["KDWATCH_PORT"]

sfn = ENV["KDWATCH_SRC"]
fail "No source given" unless sfn

dfn = File.join(File.dirname(sfn), "#{File.basename(sfn, ".*")}.html")

puts dfn

kdrfc = KramdownRFC::KDRFC.new
kdrfc.options.v3 = true
kdrfc.options.html = true

get "/" do
  sfc = File.stat(sfn).ctime
  dfc = File.stat(dfn).ctime rescue Time.at(0)
  if sfc > dfc
    warn "Rebuilding..."
    begin
      kdrfc.process sfn
    rescue StandardError => e
      warn e.to_s
    else
      warn "...done"
    end
  end
  dfc = File.stat(dfn).ctime rescue Time.at(0)
  ret = File.read(dfn)
  if sfc > dfc # somehow the above went wrong
    ret.gsub!(<<CSS, <<RED)
/* general and mobile first */
html {
CSS
/* general and mobile first */
html { border: 5px solid red;
RED
  end
  ret
end

get "/favicon.ico" do
  port_num = port.to_i % 10
  fn = File.expand_path "../../data/#{port_num}.ico", __FILE__
  warn "** fn #{fn}"
  send_file fn
end

get "/metadata.min.js" do
  # insert reload script here!
end

get "/rfc-local.css" do
  # insert local css here
end

guardfile = Tempfile.new("kdwatch-guard-")
guardfile.write(<<GF)
guard :livereload, :port => #{ENV["KDWATCH_LRPORT"]} do
  watch("#{sfn}")
end
GF
guardfile.close
gfpath = guardfile.path

rd, _wr = IO.pipe
spawn("guard -G #{gfpath}", in: rd, close_others: true)

# wrong: puts settings.port

host = "localhost" if host == "::" # work around macOS peculiarity
host = "[#{host}]" if host =~ /:/

url = "http://#{host}:#{port}"
command = "open #{url} || xdg-open #{url} || echo @@@ Please open #{url}"

if Process.respond_to?(:fork) && fork do
     begin
       # warn "** Making connection to #{host} #{port}"
       TCPSocket.new host, port
       # warn "** Successful connection to #{host} #{port}"
     rescue => _e
       # warn "** #{e.detailed_message}"
       sleep 0.5
       retry
     end
     exec(command)
     warn "** exec didn't work"
     exit!
   end
else
  spawn("sleep 3; #{command}")
end
