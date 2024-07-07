def read_rb_file
    # 作業ディレクトリ下のすべての.erbファイルを取得
    Dir.glob("**/*.rb")
end

def read_erb_file
    # 作業ディレクトリ下のすべての.erbファイルを取得
    Dir.glob("**/*.erb")
end