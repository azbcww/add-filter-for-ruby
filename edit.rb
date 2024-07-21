require 'fileutils'

def add_before_action(file_name, func_name, filter_name)
  # ファイルを読み込む
  file_content = File.read(file_name)
  
  # 正規表現でbefore_actionフィルターが既に設定されているか確認する
  before_action_regex = /before_action\s+:#{filter_name}\s*,\s+only:\s+\[:#{func_name}\]/
  if file_content.match(before_action_regex)
    puts "before_action :#{filter_name} for :#{func_name} is already present in #{file_name}"
    return
  end

  # before_actionフィルターが設定されていない場合、追加する
  insert_line = "before_action :#{filter_name}, only: [:#{func_name}]"
  # クラス定義の直後にbefore_actionを追加する
  file_content.sub!(/class\s+\w+\s*<\s*ApplicationController\s*/) do |match|
    "#{match}\n  #{insert_line}\n"
  end

  # ファイルをバックアップし、上書きする
  backup_file_name = "#{file_name}.bak"
  FileUtils.cp(file_name, backup_file_name)
  File.write(file_name, file_content)

  puts "before_action :#{filter_name} for :#{func_name} has been added to #{file_name}"
end
