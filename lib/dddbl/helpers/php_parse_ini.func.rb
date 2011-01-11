def php_parse_ini file

  raise ArgumentError, "#{file} not readable" unless File::readable? file

  config = create_deep_hash

  File.open file do |file|

    content = file.read

    while content.slice! /(\[(?<alias>.*?)\])?\s*(?<config>.*?)\s*=\s*(?<value>("(.*?)")|([^\n]*))\s*/miu do

      group = ($~[:alias] unless nil == $~[:alias]) || ''
      config[group][$~[:config]] = $~[:value]

    end

  end

  return config

end

def create_deep_hash
  Hash.new(&(p=lambda{|h,k| h[k] = Hash.new(&p)}))
end
