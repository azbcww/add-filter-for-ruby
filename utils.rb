def read_rb_file
    # 作業ディレクトリ下のすべての.erbファイルを取得
    Dir.glob("**/*.rb")
end

def read_erb_file
    # 作業ディレクトリ下のすべての.erbファイルを取得
    Dir.glob("**/*.erb")
end

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
        if sub_sexp.is_a?(Array) && sub_sexp[0] == :command
            pp "#"*40
            pp sub_sexp
        end
      if sub_sexp.is_a?(Array) && sub_sexp[0] == :command && sub_sexp[1][1] == func
        true
      else
        includes_the_call?(sub_sexp, method_name, func)
      end
    end
  end