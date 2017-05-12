#!/usr/bin/ruby

code = ARGV.shift
text = ARGV.shift
format = ARGV.shift

ARGF.binmode
data = ARGF.read()

pattern = code + (text.size * 3).chr + text
offset = data.index(pattern.force_encoding('ASCII-8BIT')) - 5

index = offset
loop do
  weight = data[index..index+1]
  index = index + 2
  weight = weight.unpack('S')[0]

  index = index + 2 # unknown

  code_lenght = data[index].unpack('C')[0]
  index = index + 1
  code = data[index..index+code_lenght-1]
  index = index + code_lenght

  text_lenght = data[index].unpack('C')[0]
  index = index + 1
  text = data[index..index+text_lenght-1]
  index = index + text_lenght

  puts format % {:code=>code, :text=>text, :weight=>weight}
  break if index >= data.size
end
