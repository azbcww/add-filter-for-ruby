def read_rb_file
    # 作業ディレクトリ下のすべての.erbファイルを取得
    Dir.glob("**/*.rb")
end

def read_erb_file
    # 作業ディレクトリ下のすべての.erbファイルを取得
    Dir.glob("**/*.erb")
end

def read_app_erb_file
  Dir.glob("../#{ENV["DIR"]}/app/views/**/*.erb")
end

def read_app_rb_file
  Dir.glob("../#{ENV["DIR"]}/app/controllers/**/*.rb")
end

def find_methods_with(sexp, func, result = [])
  return result unless sexp.is_a?(Array)
  if sexp[0] == :command
    method_name = sexp[1][1]
    filter_name = sexp[2][1][0][1][1][1]
    select_adverb = sexp[2][1][1][1][0][1][1]
    pp method_name
    pp filter_name
    pp select_adverb
    sexp[2][1][1][1][0][2][1].each do |func|
      pp func[1]
    end
  else
    sexp.each do |sub_sexp|
      find_methods_with(sub_sexp, func, result)
    end
  end

  result
end

def find_before_action_with(sexp, func, result = [])
  return [false, result] unless sexp.is_a?(Array)
  ans = [false,[]]
  if sexp[0] == :command
    method_name = sexp[1][1]
    filter_name = sexp[2][1][0][1][1][1]
    select_adverb = sexp[2][1][1][1][0][1][1]
    funcs = []
    sexp[2][1][1][1][0][2][1].each do |func|
      funcs.push(func[1])
    end
    return [true, [method_name, filter_name, select_adverb, funcs]]
  else
    sexp.each do |sub_sexp|
      tmp = find_before_action_with(sub_sexp, func, result)
      if tmp[0] && tmp[1].length==4
        ans = tmp
      end
    end
  end
  return ans
end

def edit_before_action_with(sexp, func, filter, found)
  return sexp unless sexp.is_a?(Array)
  sexp.map do |element|
    if element.is_a?(Array) && element[0] == :command
      method_name = element[1][1]
      filter_name = element[2][1][0][1][1][1]
      select_adverb = element[2][1][1][1][0][1][1]
      funcs = []
      element[2][1][1][1][0][2][1].each do |set|
        funcs.push(set[1].gsub(',', ''))
      end
      if method_name == "before_action" && filter_name == filter && select_adverb=="only:"
        if funcs.include? func
          found << 1
        else
          before_func = element[2][1][1][1][0][2][1][-1]
          element[2][1][1][1][0][2][1].push([:@tstring_content, func, [before_func[2][0], before_func[2][1]+before_func[1].length+2]])
          found << 2
        end
      end
    else
      edit_before_action_with(element, func, filter, found)
    end
  end
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
      return true
  else
      return false
  end
end