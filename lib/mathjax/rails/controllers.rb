class Mathjax::Rails::MathjaxRailsController < ActionController::Base
  def giveOutStaticFile
    ext = ''
    ext = ".#{params[:format]}" if params[:format]
    filename = "#{params[:uri]}#{ext}"

    clean_path = Pathname.new(filename).cleanpath.to_s
    return head :not_found if clean_path != filename

    file = File.join(Gem.dir, 'gems', "mathjax-rails-#{Mathjax::Rails::VERSION}", 'vendor', Mathjax::Rails::DIRNAME, filename)
    if File.exist?(file)
      extname = File.extname(filename)[1..-1]
      mime_type = Mime::Type.lookup_by_extension(extname)

      options = {disposition: 'inline'}
      options[:type] = mime_type.to_s unless mime_type.nil?

      send_file file, options
    else
      head :not_found
    end
  end
end
