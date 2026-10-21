Then(/^the HTML report includes the video attachment as base64$/) do
  report = File.read(File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'aruba', 'project', 'public', 'index.html'))

  assert_match(/"body":"[A-Za-z0-9+\/=]+","contentEncoding":"BASE64","mediaType":"video\/x-matroska"/, report)
end

And(/^Then the XML report for JUnit and XUnit contains a time tag with 6 decimal numbers$/) do
  @doc = Nokogiri::HTML(File.open(::File.join(::File.dirname(__FILE__), '..', '..', 'tmp', 'aruba', 'project', 'public', 'TEST-features-true_assertions.xml')))

  assert @doc.xpath("//testsuite").to_s.match(/time="\d+.\d{6}\"/)
  @doc.xpath("//testcase").to_s.scan(/time="\d+.\d+\"/) do |times|
    assert times.match(/time="\d+.\d{6}\"/)
  end
end