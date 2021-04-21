Given /^true$/ do
    assert true
end

Given(/^a known video file$/) do
  video_file =::File.join(::File.dirname(__FILE__), '..','..', 'public', 'test_embed_video.mkv')
  file = File.open video_file
  @video_file = file.read
end



When(/^someone uses the embed function$/) do
  attach @video_file, "video/x-matroska"
 end



