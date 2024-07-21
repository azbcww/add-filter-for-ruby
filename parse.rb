require 'ripper'
require 'pp'
require './utils.rb'

def parse_all
    # 作業ディレクトリ下のすべての.rbファイルを取得
    ruby_files = read_app_rb_file

    # 各ファイルをパースして出力
    ruby_files.each do |filename|
        puts "\n" + "-"*20 + "Parsing #{filename}:" + "-"*20 + "\n\n"
        code = File.read(filename)
        parsed_code = Ripper.sexp(code)
        pp parsed_code
        check(parsed_code, filename, "p")
    end
end

def parse_file(filename)
    begin
        code = File.read(filename)
        parsed_code = Ripper.sexp(code)
        return parsed_code
    rescue => e
        return []
    end
end

def parse_edit(editing_file_name, func_name)
    parsed_code = parse_file(editing_file_name)
    return [0] if parsed_code.length==0
    new_code = Marshal.load(Marshal.dump(parsed_code))
    found = []
    edit_before_action_with(new_code,func_name, ENV["FIL"], found)
    found
end