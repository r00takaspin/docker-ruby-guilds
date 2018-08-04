require 'digest'
require 'benchmark'

GUILD_NUMBER = 12

def count_md5(id)
  tmp = id.to_s
  1_000_000.times { tmp = Digest::MD5.hexdigest(tmp) }
  tmp
end

def run_guild(id)
  tmp = count_md5(id)
  Guild.parent.send(tmp)
rescue Exception => _
  Guild.parent.send(nil)
end

GUILD_NUMBER.times do
  Guild.new do
    id = Guild.receive
    run_guild(id)
  end
end

puts '>> Sequential: '

Benchmark.bm { |x| x.report { GUILD_NUMBER.times { count_md5(Thread.current.object_id) } } }


child_guilds = Guild.list.reject { |g| g.__id__ == Guild.current.__id__ }

child_guilds.each { |g| g << g.__id__ }

puts '>> Guilds:'

Benchmark.bm do |x|
  x.report { GUILD_NUMBER.times { Guild.receive } }
end

puts '>> Threads:'

Benchmark.bm do |x|
  x.report do
    threads = []
    GUILD_NUMBER.times { threads << Thread.new { count_md5(Thread.current.object_id) } }
    threads.each(&:join)
  end
end
