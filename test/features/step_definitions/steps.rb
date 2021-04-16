And(/^Then the HTML report contains a video tag linked to the given file$/) do
  @doc = Nokogiri::HTML(File.open(::File.join(::File.dirname(__FILE__), '..', '..', 'tmp', 'aruba', 'project', 'public', 'index.html')))
  raise "Video has not generated" unless @doc.xpath("//video")
  raise "Video media type not found" unless @doc.xpath("//source/@src")
end

And(/^The video can be downloaded$/) do
  assert_equal "test_embed_video.mkv", @doc.xpath("//div[@id='video_div_0']/a/@href").to_s
  assert_equal "test_embed_video.mkv", @doc.xpath("//div[@id='video_div_0']/a/@download").to_s
end


And(/^Then the XML report for JUnit and XUnit contains a time tag with 6 decimal numbers$/) do
  @doc = Nokogiri::HTML(File.open(::File.join(::File.dirname(__FILE__), '..', '..', 'tmp', 'aruba', 'project', 'public', 'TEST-features-true_assertions.xml')))

  assert @doc.xpath("//testsuite").to_s.match(/time="\d+.\d{6}\"/)
  @doc.xpath("//testcase").to_s.scan(/time="\d+.\d+\"/) do |times|
    assert times.match(/time="\d+.\d{6}\"/)
  end
end