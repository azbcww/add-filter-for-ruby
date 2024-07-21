require 'ripper'
require 'erb'
require './utils.rb'
require './edit.rb'
require './parse.rb'

# ERBファイルからRubyコードを抽出する関数
def extract_ruby_code(erb_content)
  ruby_code = []
  erb_scanner = ERB::Compiler::Scanner.new(erb_content, nil, true)
  erb_content.scan(/^\s*(?!#)\s*<%=?\s*(.*?)\s*%>/m).each do |match|
    ruby_code << "#{match.first.strip}"
  end
  ruby_code.join("\n")
end

def extract_all
  changed_filenames = []
  erb_files = read_app_erb_file
  puts "-" * 20 + "erb files" + "-" * 20
  puts erb_files
  puts "-" * 20 + "erb files with #{ENV["CMD"]}" + "-" * 20
  erb_files.each do |filename|
    erb_content = File.read(filename)
    extracted_ruby_code = extract_ruby_code(erb_content)
    parsed_code = Ripper.sexp(extracted_ruby_code)
    if check_extract(parsed_code, filename, "#{ENV["CMD"]}")
        changed_filenames.push(filename)
    end
  end
  puts "-" * 20 + "func and controller files" + "-" * 20
  edit_controller(changed_filenames)
end

def edit_controller(filenames)
  if filenames.length==0
    return
  end
  filenames.each do |file_name|
    # パスを分割して配列にする
    parts = file_name.split('/')

    # ディレクトリ名を取得
    editing_file_name = "../#{ENV["DIR"]}/app/controllers/#{parts[-2]}_controller.rb"
    # ファイル名のfunc部分を取得
    func_name = (parts[-1].split('.'))[0]

    found = parse_edit(editing_file_name, func_name)

    if found.length==0
      puts "add before_action(#{func_name}): #{editing_file_name}"
      # 追加する文字列
      string_to_add = "  before_action :#{ENV["FIL"]}, only: %i[#{func_name}]\n"
      # ファイルを読み込む
      content = File.read(editing_file_name)
      # class行の直後に追加する文字列を挿入
      modified_content = content.gsub(/(class.*?\n)/, "\\1#{string_to_add}")
      # 修正した内容をファイルに書き込む
      File.write(editing_file_name, modified_content)
    elsif found[0]==2
      puts "add only func(#{func_name}): #{editing_file_name}"
      # 追加する文字列
      string_to_add = "#{func_name}"
      # ファイルを読み込む
      content = File.read(editing_file_name)
      # before_action の行を見つけて、show の後ろに文字列を追加
      modified_content = content.gsub(/^\s*(before_action\s+:#{ENV["FIL"]},\s*only:\s*%i\[[^\]]*\])/) do |match|
        # match の中で show の後ろに追加したい文字列
        match.gsub(/(%i\[)([^\]]*)(\])/) do |inner_match|
          prefix = $1  # %i[
          content = $2 # 任意の文字列
          suffix = $3  # ]
      
          # 任意の文字列の後ろに追加する文字列を追加
          "#{prefix}#{content} #{func_name}#{suffix}"
        end
      end
      # 修正した内容をファイルに書き込む
      File.write(editing_file_name, modified_content)
    elsif found[0]==1
      puts "already set(#{func_name}): #{editing_file_name}"
    elsif found[0]==0
      puts "not found file: #{editing_file_name}"
    end
  end
end
