require './hook_lying_syncer'

class Person
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

def quote(str)
  return str unless str.is_a? String
  "\"#{str}\""
end

def expect(expected, actual, msg=nil)
  if actual == expected
    print "."
  else
    puts
    puts msg ? msg : "Expected #{quote(expected)}, got #{quote(actual)}"
    puts "Caller: #{caller(1,1)}"
  end
end

p = Person.new("Dave")
kinds_getter = ->(sym) {
  matches = /\Afind_(\w+)_widgets\Z/.match(sym)
  matches[1].split("_") if matches
}
hls = HookLyingSyncer.new(p, kinds_getter) do |p, kinds, *moreargs|
  addons = moreargs.any? ? ", with #{moreargs.join(" and ")}" : nil
  "#{p.name} wants #{kinds.join(" ")} widgets#{addons}"
end

expect(p.respond_to?(:find_green_widgets), false)
expect(hls.respond_to?(:find_green_widgets), true)

expect(hls.find_big_widgets(:foo), "Dave wants big widgets, with foo")

expect(hls.find_big_green_widgets(:foo, :bar),
       "Dave wants big green widgets, with foo and bar")

expect(hls.name, "Dave")

p = Person.new("Chris")
expect(p.name, "Chris")
expect(hls.name, "Dave")

name_getter = ->(sym) {
  matches = /\Asay_to_(\w+)\Z/.match(sym)
  matches[1].split("_and_").map(&:capitalize) if matches
}
hls2 = HookLyingSyncer.new(hls, name_getter) do |hls1, names, *moreargs|
  "#{hls1.name} says #{moreargs.join(" and ")} to #{names.join(" and ")}"
end

expect(p.respond_to?(:say_to_fred), false)
expect(hls.respond_to?(:say_to_fred), false)
expect(hls2.respond_to?(:say_to_fred), true)

expect(hls2.say_to_fred("hail", "well met"),
       "Dave says hail and well met to Fred")

expect(hls2.say_to_bill_and_ted("excellent!"),
       "Dave says excellent! to Bill and Ted")

expect(hls2.find_green_widgets, "Dave wants green widgets")

puts "\nDone!"
