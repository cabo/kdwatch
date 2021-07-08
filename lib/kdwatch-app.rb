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
require "net/http/persistent"

host = ENV["KDWATCH_HOST"]
port = ENV["KDWATCH_PORT"]

sfn = ENV["KDWATCH_SRC"]
fail "No source given" unless sfn

dfn = File.join(File.dirname(sfn), "#{File.basename(sfn, ".*")}.html")

puts dfn

get "/" do
  sfc = File.stat(sfn).ctime
  dfc = File.stat(dfn).ctime rescue Time.at(0)
  if sfc > dfc
    warn "Rebuilding..."
    system("time kdrfc -3h --no-txt #{sfn}")
    warn "...done"
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

host = "::1" if host == "::" # work around macOS peculiarity
host = "[#{host}]" if host =~ /:/

url = "http://#{host}:#{port}"

spawn("sleep 5; open #{url} || xdg-open #{url} || echo @@@ Please open #{url}")


