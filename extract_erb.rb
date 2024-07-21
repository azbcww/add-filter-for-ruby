require 'ripper'
require 'erb'
require './utils.rb'

# ERBファイルからRubyコードを抽出する関数
def extract_ruby_code(erb_content)
  ruby_code = []
  erb_scanner = ERB::Compiler::Scanner.new(erb_content, nil, true)
  erb_content.scan(/<%=?\s*(.*?)\s*%>/m).each do |match|
    ruby_code << "#{match.first.strip}"
  end
  ruby_code.join("\n")
end

def extract_all
  changed_filenames = []
  erb_files = read_app_erb_file
  pp erb_files
  erb_files.each do |filename|
    puts "Extracting Ruby code from #{filename}:"
    erb_content = File.read(filename)
    extracted_ruby_code = extract_ruby_code(erb_content)
    parsed_code = Ripper.sexp(extracted_ruby_code)
    puts "-" * 40
    pp parsed_code
    puts "-" * 40
    # check_extract(parsed_code, filename, "paginate")
    if check_extract(parsed_code, filename, "#{ENV["CMD"]}")
        changed_filenames.push(filename)
    end
  end

  export_url(changed_filenames)
end

def export_url(filenames)
  if filenames.length==0
    return
  end
  puts "\nchanged files:\n"
  filenames.each do |filename|
      puts filename
  end
end
