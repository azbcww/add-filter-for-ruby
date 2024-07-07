require 'ripper'
require 'pp'
require './utils.rb'

def parse_all
    # 作業ディレクトリ下のすべての.rbファイルを取得
    ruby_files = read_rb_file

    # 各ファイルをパースして出力
    ruby_files.each do |filename|
        puts "\n" + "-"*20 + "Parsing #{filename}:" + "-"*20 + "\n\n"
        code = File.read(filename)
        parsed_code = Ripper.sexp(code)
        check(parsed_code, filename, "p")
    end
end

def check(parsed_code, filename, func)
  methods_with_p = find_methods_with(parsed_code, func)
  if methods_with_p.any?
      puts "Methods containing '"+func+"' in #{filename}: #{methods_with_p.join(', ')}"
  else
      puts "No methods containing '"+func+"' found in #{filename}."
  end
end