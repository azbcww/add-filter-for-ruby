require 'ripper'
require 'erb'

# ERBファイルからRubyコードを抽出する関数
def extract_ruby_code(erb_content)
  ruby_code = []
  erb_scanner = ERB::Compiler::Scanner.new(erb_content, nil, true)
  erb_content.scan(/<%=?\s*(.*?)\s*%>/m).each do |match|
    ruby_code << "#{match.first.strip}"
  end
  ruby_code.join("\n")
end

# 作業ディレクトリ下のすべての.erbファイルを取得
erb_files = Dir.glob("**/*.erb")

# 各ファイルからRubyコードを抽出して出力
erb_files.each do |filename|
  puts "Extracting Ruby code from #{filename}:"
  erb_content = File.read(filename)
  extracted_ruby_code = extract_ruby_code(erb_content)
  puts "-" * 40
  parsed_code = Ripper.sexp(extracted_ruby_code)
  pp parsed_code
  puts "-" * 40
end
