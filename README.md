# Avant Ruby Programming Assigment

This is a quick solution to the [Avant Programming Assignment](https://github.com/avantcredit/programming_challenges/blob/master/twitter_test)

## Requirements and Installation
* ruby (currently using ruby-2.1.5)
* bundler (for installing gems)
* `bundle install` to install the gems listed in the Gemfile.
* twitter_credentials.yml file is required containing your api keys

## Running
```bash
bundle exec ruby t_stream.rb
```

## Optional:
### How would you implement it so that if you had to stop the program and restart, it could pick up from the total word counts that you started from?

I would daemonize the process so it is easy to start and stop. This is easily accomplished using the daemons gem (and the twitterstream gem alread uses if to make daemonizing trivial). Then when it stops, I would write out the list of unique words and their counts to a CSV file with the first row being the total word count. Finally, I would add OptionParser and add a command line flag for specifying the csv filename to read the data from for continuing where it left off.