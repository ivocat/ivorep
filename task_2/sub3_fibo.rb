fibo = [1]
loop do
  fibo.push(fibo[-1] + fibo[-2].to_i)
  break if fibo[-1] + fibo[-2] >= 100
end
print "#{fibo}\n"
