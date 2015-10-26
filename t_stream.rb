require 'tweetstream'
require 'CSV'
require 'yaml'
require "#{Dir.pwd}/tweet_words_counter.rb"

twitter_api_keys = YAML.load_file("twitter_credentials.yml")
TweetStream.configure do |config|
  config.consumer_key       = twitter_api_keys['consumer_key']
  config.consumer_secret    = twitter_api_keys['consumer_secret']
  config.oauth_token        = twitter_api_keys['oauth_token']
  config.oauth_token_secret = twitter_api_keys['oauth_token_secret']
  config.auth_method        = :oauth
end

@started_at = Time.now
@run_for = 300
@tweet_count = 0
stop_words = CSV.read("stop-word-list.csv").first.map(&:strip)
#Source: http://xpo6.com/list-of-english-stop-words/ plus a few words I added that are twitter slang words or shorthand.

tweet_words_counter = TweetWordsCounter.new(stop_words)

@client = TweetStream::Client.new

@client.on_limit do |skip_count|
  puts 'hit api limit'
end

@client.on_enhance_your_calm do
  puts 'hit api limit -- enhance your calm'
end

@client.on_error do |message|
  puts "Error: #{message}"
end

@client.sample({language: "en"}) do |status, client|
  @tweet_count += 1

  tweet_text = status.text.dup
  tweet_words_counter.add_tweet(tweet_text)

  puts "Tweet Count: #{sprintf("%5d", @tweet_count)}  |   Run For: #{sprintf("%3d",(Time.now - @started_at).round)} Seconds  |   total word count: #{sprintf("%6d",tweet_words_counter.word_count)}  |   Unique Words: #{sprintf("%6d",tweet_words_counter.words_hash.size)}"

  if (Time.now - @started_at) > @run_for
    client.stop
    puts "#################################################################"
    puts "#################################################################"
    puts "Total Word Count: #{tweet_words_counter.word_count}"
    puts "Top 10 Words"
    puts tweet_words_counter.top_words
  end
end
