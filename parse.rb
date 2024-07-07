require 'ripper'
require 'pp'

def find_methods_with_p(sexp, result = [])
  return result unless sexp.is_a?(Array)
  if sexp[0] == :def
    method_name = sexp[1][1]
    body = sexp[3]
    if includes_p_call?(body, method_name)
      result << method_name
    end
  else
    sexp.each do |sub_sexp|
      find_methods_with_p(sub_sexp, result)
    end
  end

  result
end

def includes_p_call?(sexp, method_name)
  return false unless sexp.is_a?(Array)

  sexp.any? do |sub_sexp|
    if sub_sexp.is_a?(Array) && sub_sexp[0] == :command && sub_sexp[1][1] == "p"
      true
    else
      includes_p_call?(sub_sexp, method_name)
    end
  end
end

# 作業ディレクトリ下のすべての.rbファイルを取得
ruby_files = Dir.glob("**/*.rb")

# 各ファイルをパースして出力
ruby_files.each do |filename|
  puts "Parsing #{filename}:"
  code = File.read(filename)
  parsed_code = Ripper.sexp(code)
  p '#' * 40
  pp parsed_code
  methods_with_p = find_methods_with_p(parsed_code)
  if methods_with_p.any?
    puts "Methods containing 'p' in #{filename}: #{methods_with_p.join(', ')}"
  else
    puts "No methods containing 'p' found in #{filename}."
  end
  puts "-" * 40
end