# RubyNovice

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/ruby_novice`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_novice'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_novice

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruby_novice. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RubyNovice project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ruby_novice/blob/master/CODE_OF_CONDUCT.md).
# editer_learner
まずはforkしてcloneして自分のフォルダに入れてください．

# 動かし方
libの中にruby_novice.rbがあるので:

    $ ruby ruby_novice
    
で実行可能．

# 実行してから
実行すると1〜4のランダムな数字が出力されます．これはどのファイルの問題が出されたかの数字なので特に気にする必要はありません．
実行したら:

    $ Command + n
    
で新しいターミナルを開いて，ruby_noviceのあるフォルダで:

    $ emacs question.rb answer.rb

と打つと上下分割されたものがでてくるので上のquestin.rbに書かれた内容をanswer.rbにtypingする:

    $ C-x C-c
    
で保存するとそれまでにかかった時間が表示される．
これが実行から終了までの一連の流れになります．




