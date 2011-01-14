def php_parse_ini file

  raise ArgumentError, "#{file} not readable" unless File::readable? file

  config = create_deep_hash

  File.open file do |file|

    content = file.read
    group = ''

    while content.slice! /(\[(?<alias>.*?)\])?\s*(?<config>.*?)\s*=\s*(?<value>("(.*?)")|([^\n]*))\s*/miu do

      group = $~[:alias] || group
      config[group][$~[:config]] = $~[:value]

      # remove " and ' and whitespaces
      # would be nicer to figure out a correct regexp
      # but for now it ...works
      # it's propbly gonna be fucked up by the sql-queries though.
      config[group][$~[:config]].tr! "'", ""
      config[group][$~[:config]].tr! '"', ''
      config[group][$~[:config]].strip!

    end

  end

  return config

end

def create_deep_hash
  Hash.new(&(p=lambda{|h,k| h[k] = Hash.new(&p)}))
end

def parse_handler_config config

  config.split

end