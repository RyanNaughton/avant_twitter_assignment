class TweetWordsCounter

  WORDS_REGEX = /(?!'.*')\b([[a-zA-Z]']+)\b/
  TWITTER_SHORT_URL_REGEX = /https:\/\/t.co\/\w{10}/

  attr_accessor :word_count, :words_hash, :stop_words

  def initialize(stop_words)
    @word_count = 0
    @words_hash = {}
    @stop_words = stop_words
  end

  def add_tweet(tweet_text)
    tweet_text.gsub!(TWITTER_SHORT_URL_REGEX,"")
    words = tweet_text.scan(WORDS_REGEX).flatten.map(&:downcase)
    self.word_count += words.size
    words_without_stop_words = words - stop_words
    words_without_stop_words.each{ |w| increment_word_count(w) }
  end

  def top_words(count = 10)
    words_hash.sort_by{|k,v|v*-1}[0..(count-1)].map{|x| x[0]}
  end

  def increment_word_count(w)
    if words_hash[w].nil?
      words_hash[w] = 1
    else
      words_hash[w] += 1
    end
  end

end