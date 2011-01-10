# To change this template, choose Tools | Templates
# and open the template in the editor.

class ConfigParser
  
  def readDir(dir)

    if Dir.exists? dir then
      Dir.foreach(dir) do |file|
        self.readFile file unless file.directory? file
      end
    end

  end

  def readFile(file)

    queries = []
      query = {}

    muff = file.each do |line|

      if line =~ /\[(.*)\]/ then

        queries << query unless query.empty?
        query = {}
        
        data = Regexp.last_match
        query[:alias] = data[1] unless data[1].empty?

      elsif  line=~ /(.*?)\s=\s"(.*)"/mu then
        
        data = Regexp.last_match
        query[data[1]] = data[2] unless data[1].empty? || data[2].empty?

      end

    end

    queries << query

    p queries

  end

end