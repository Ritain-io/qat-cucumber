require 'cucumber/formatter/html'

#Extension to the cucumber module adding the embed video options
module Cucumber
  #Extension to the formatter module adding the embed video options
  module Formatter
    #Extension to the html class adding the embed video options
    class Html
      #Method embed that also contains options to embed video case the extension is met
      def embed(src, mime_type, label)
        case (mime_type)
          when /^image\/(png|gif|jpg|jpeg)/
            unless File.file?(src) or src =~ /^data:image\/(png|gif|jpg|jpeg);base64,/
              type = mime_type =~ /;base[0-9]+$/ ? mime_type : mime_type + ";base64"
              src  = "data:" + type + "," + src
            end
            embed_image(src, label)
          when /^text\/plain/
            embed_text(src, label)
          when /^video\/\w+/
            embed_video(src,mime_type, label)
        end
      end

      #Method to embed the video in the HTML Report
      def embed_video(src,mime_type, label)
        @video_id ||= 0

        if @io.respond_to?(:path) and File.file?(src)
          out_dir = Pathname.new(File.dirname(File.absolute_path(@io.path)))
          src     = Pathname.new(File.absolute_path(src)).relative_path_from(out_dir)
        end

        @builder.span(:class => 'embed') do |pre|
          pre << %{
          <a href="" onclick="video=document.getElementById('video_div_#{@video_id}'); video.style.display = (video.style.display == 'none' ? 'block' : 'none');return false"><br>#{label}</a><br>&nbsp;
          <div id="video_div_#{@video_id}" style="display: none">
          <video id="video_#{@video_id}" autostart="0" width="800" height="600" controls> <source src="#{src}"  type="#{mime_type}" ></video><br>
          <a href="#{src}" download="#{src}">Download Video</a>
          </div>}
        end

        @video_id += 1
      end
    end
  end
end

