#!/usr/bin/ruby

format = ARGV.shift
ARGF.binmode
data = ARGF.read()

offset = -1
pattern = Regexp.new(/....([\x01-\x06])([a-z]{1,7})/n)
loop do
  match = pattern.match(data, offset + 1)
  offset = match.begin(0)
  code_length = match[1].unpack('C')[0]
  if code_length == match[2].size or code_length == match[2].size - 1
    text_length = data[offset+4+1+code_length].unpack('C')[0]
    if text_length > 0
      text = data[offset+4+1+code_length+1..offset+4+1+code_length+1+text_length-1].force_encoding('utf-8')
      begin
        is_utf8 = text =~ /^(\p{Han}|[[:graph:]])+$/u
      rescue Exception
        is_utf8 = false
      end
      break if is_utf8
    end
  end
end

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
