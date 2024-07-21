def read_rb_file
    # 作業ディレクトリ下のすべての.erbファイルを取得
    Dir.glob("**/*.rb")
end

def read_erb_file
    # 作業ディレクトリ下のすべての.erbファイルを取得
    Dir.glob("**/*.erb")
end

#docker run -v ./../:/mnt --env DIR=myapp --rm image_nameの形で呼ぶ
def read_app_erb_file
  Dir.glob("../#{ENV["DIR"]}/app/views/**/*.erb")
end

def find_methods_with(sexp, func, result = [])
  return result unless sexp.is_a?(Array)
  if sexp[0] == :def
    method_name = sexp[1][1]
    body = sexp[3]
    if includes_the_call?(body, method_name, func)
      result << method_name
    end
  else
    sexp.each do |sub_sexp|
      find_methods_with(sub_sexp, func, result)
    end
  end

  result
end

def includes_the_call?(sexp, method_name, func)
  return false unless sexp.is_a?(Array)

  sexp.any? do |sub_sexp|
    if sub_sexp.is_a?(Array) && sub_sexp[0] == :command && sub_sexp[1][1] == func
      true
    else
      includes_the_call?(sub_sexp, method_name, func)
    end
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

  


def find_methods_with_extract(sexp, func, result = [])
  return result unless sexp.is_a?(Array)
  if sexp[0] == :command
    method_name = sexp[1][1]
    body = sexp[3]
  if sexp[1][1] == func
      result << method_name
    end
  else
    sexp.each do |sub_sexp|
      find_methods_with_extract(sub_sexp, func, result)
    end
  end

  result
end


def check_extract(parsed_code, filename, func)
  methods_with_p = find_methods_with_extract(parsed_code, func)
  if methods_with_p.any?
      puts "Methods containing '"+func+"' in #{filename}: #{methods_with_p.join(', ')}"
  else
      puts "No methods containing '"+func+"' found in #{filename}."
  end
end