# # ベースイメージとしてDebianを使用
# FROM debian:latest

# # メンテナ情報を記載
# LABEL maintainer="your_email@example.com"

# # 必要なパッケージをインストール
# # RUN apt-get update && apt-get install -y sudo

# # 新しいユーザーを作成
# # RUN useradd -m dockeruser && echo "dockeruser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# # 必要なパッケージをインストール
# RUN apt-get update && apt-get install -y \
#     curl \
#     gnupg2 \
#     build-essential

# # RVM（Ruby Version Manager）のインストール
# RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
#     curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - && \
#     curl -sSL https://get.rvm.io | bash -s stable

# # RVMを使って最新のRubyをインストール
# RUN /bin/bash -l -c "rvm install ruby --latest"

# # ワーキングディレクトリを設定
# WORKDIR /mnt

# # ユーザーを切り替え
# # USER dockeruser

# CMD ["/bin/bash", "-l", "-c", "ruby main.rb"]

# ベースイメージとして公式のRubyイメージを使用
FROM ruby:3.1

# 作業ディレクトリを設定
# WORKDIR /usr/src/app

# 必要なファイルをコンテナにコピー
# COPY . .

# # ワーキングディレクトリを設定
WORKDIR /mnt

# Rubyファイルをパースするスクリプトを実行
CMD ["ruby", "parse.rb"]