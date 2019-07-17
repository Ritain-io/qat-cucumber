And(/^Then the HTML report contains a video tag linked to the given file$/) do
  @doc = Nokogiri::HTML(File.open(::File.join(::File.dirname(__FILE__), '..', '..', 'tmp', 'aruba', 'project', 'public', 'index.html')))
  assert_equal "test_embed_video.mkv", @doc.xpath("//div[@id='video_div_0']/video[@id='video_0']/source/@src").to_s
  assert_equal "video/mkv", @doc.xpath("//div[@id='video_div_0']/video[@id='video_0']/source/@type").to_s
end

And(/^The video can be downloaded$/) do
  assert_equal "test_embed_video.mkv", @doc.xpath("//div[@id='video_div_0']/a/@href").to_s
  assert_equal "test_embed_video.mkv", @doc.xpath("//div[@id='video_div_0']/a/@download").to_s
end


And(/^Then the XML report for JUnit and XUnit contains a time tag with 3 decimal numbers$/) do
  @doc = Nokogiri::HTML(File.open(::File.join(::File.dirname(__FILE__), '..', '..', 'tmp', 'aruba', 'project', 'public', 'TEST-features-true_assertions.xml')))

  assert @doc.xpath("//testsuite").to_s.match(/time="\d+.\d{3}\"/)
  @doc.xpath("//testcase").to_s.scan(/time="\d+.\d+\"/) do |times|
    assert times.match(/time="\d+.\d{3}\"/)
  end
end