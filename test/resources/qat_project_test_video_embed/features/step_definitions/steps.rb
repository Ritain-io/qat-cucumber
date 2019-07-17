Given /^true$/ do
    assert true
end

Given(/^a known video file$/) do
  @video_file =::File.join(::File.dirname(__FILE__), '..','..', 'public', 'test_embed_video.mkv')
end



When(/^someone uses the embed function$/) do
  embed @video_file, "video/mkv", "Video"
 end



