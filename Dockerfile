FROM ruby:3.1

WORKDIR /mnt/add-filter-for-ruby

# Rubyファイルをパースするスクリプトを実行
# CMD ["ruby", "parse.rb"]
CMD ["ruby", "main.rb"]
