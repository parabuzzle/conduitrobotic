#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/config/boot'
RAILS_ROOT = "."
PUBLICDIR = File.expand_path("public", RAILS_ROOT)
require 'mime/types'
require 'config/initializers/S3'
AWS_ACCESS_KEY_ID = ENV['CR_S3_key']
AWS_SECRET_ACCESS_KEY = ENV['CR_S3_secret']
BUCKET_NAME = 'assets.conduitrobotic.com'
MIME::Type.new('application/x-javascript') do |t|
  t.extensions = ['js']
  MIME::Types.add(t)
end
def upload_asset(path)
  if File.directory?(path)
    # go recursive
    Dir.foreach(path) {|file|
      if /^[^\.].*$/.match(file)
        upload_asset("#{ path }/#{ file }")
      end
    }
  else
    # it's a file, check for validity and upload it
    if /^#{ PUBLICDIR }\/(.+[^~])$/.match(path) && File.readable?(path)
      key = Regexp.last_match[1]
      mime = MIME::Types.type_for(key).to_s
      if mime.length == 0
        mime = 'text/plain'
      end
      puts "uploading #{ path } as #{ key } mime #{ mime }"
      datafile = File.open(path)
      conn = S3::AWSAuthConnection.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, true)
      conn.put(BUCKET_NAME, key, datafile.read,
        { "Content-Type" => mime, "Content-Length" => File.size(path).to_s,
          "Content-Disposition"=> "inline;filename=#{File.basename(key).gsub(/\s/, '_')}",
          "x-amz-acl" => "public-read" })
    end
  end
end
if ARGV.length > 0
  # some files were selected
  for arg in ARGV
    upload_asset(File.expand_path(arg))
  end
else
  # no files were specified, try to upload everything public
  upload_asset(PUBLICDIR)
end