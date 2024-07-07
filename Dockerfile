FROM ruby:3.1

WORKDIR /mnt

# Rubyファイルをパースするスクリプトを実行
CMD ["ruby", "parse.rb"]
# CMD ["ruby", "extract_erb.rb"]