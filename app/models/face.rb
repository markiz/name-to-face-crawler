require 'fileutils'
require 'digest/md5'
require 'fiber'
require 'net/http'
require 'uri'
require 'cgi'
class Face
  attr_accessor :name

  def initialize(name)
    @name = name
    precache_face!
  end # initialize

  def path
    "#{faces_cache_dir}/#{filename}"
  end # path

  def filename
    Digest::MD5.hexdigest(name) + ".png"
  end # filename

  def faces_cache_dir
    dir = Rails.env.production? ? root + "/../shared/faces" : root + "/public/faces"
    FileUtils.mkdir_p(dir)
    dir
  end # faces_dir

  def precache_face!
    unless File.exists?(path)
      uri_args = "name=#{CGI.escape(name)}"
      html = Net::HTTP.get(URI.parse("http://turnyournameintoaface.com/?#{uri_args}"))
      img_path = html.match(/<img src="(.*?)".*?>/)[1]
      img = Net::HTTP.get(URI.parse("http://turnyournameintoaface.com/#{img_path}"))
      File.open(path, 'wb') {|f| f.write img }
    end
  rescue Exception => e
    puts "Error: #{e.inspect}"
    Rails.logger.error "#{e}: #{e.inspect}"
  end # precache_face!

  def root
    File.expand_path(Rails.root)
  end

end