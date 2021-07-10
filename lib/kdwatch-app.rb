require_relative "kdwatch/version"
require 'bundler'

# Bundler.require
require "bundler"
require "thin"
# require "guard-livereload"
require "rack-livereload"
require "guard"
require "sinatra"
require "kramdown-rfc2629"
ENV["KDRFC_PREPEND"] = "time"
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
  File.read(dfn)
end

get "/metadata.min.js" do
  # insert reload script here!
end

get "/rfc-local.css" do
  # insert local css here
end

File.write(".Guardfile", <<GF)
guard :livereload, :port => #{ENV["KDWATCH_LRPORT"]} do
  watch("#{sfn}")
end
GF

rd, _wr = IO.pipe
spawn("guard -G .Guardfile", in: rd, close_others: true)

# wrong: puts settings.port

host = "localhost" if host == "::" # work around macOS peculiarity
host = "[#{host}]" if host =~ /:/

url = "http://#{host}:#{port}"

spawn("sleep 5; open #{url} || xdg-open #{url} || echo @@@ Please open #{url}")


