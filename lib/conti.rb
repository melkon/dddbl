require 'continuation'

 set_trace_func proc { |event, file, line, id, binding, classname|
       printf "%8s %s:%-2d %10s %8s\n", event, file, line, id, classname
    }

$lines = {}

def line(symbol)
  callcc  do |c|
     $lines[symbol] = c
  end
end

def goto(symbol)
  $lines[symbol].call
end

i = 0
line 10
puts i += 1
goto 10 if i < 5

line 20
puts i -= 1
goto 20 if i > 0