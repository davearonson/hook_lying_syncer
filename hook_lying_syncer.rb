class HookLyingSyncer

  # object is the object being wrapped, for purposes of endowing it with some
  # pattern of methods it should respond to.
  #
  # matcher is a lambda that returns the matches.  if there are any, it should
  # return an array.  if there are none, it may return an empty array, nil, or
  # false.
  #
  # block is what you want to do with the object, the matches, and any
  # additional args given to the dynamic method.  ideally this should include
  # actually declaring the method, so further uses won't be inefficiently done
  # via method_missing.  maybe a later version of hls will do that for you.
  def initialize(object, matcher, &block)
    @object = object
    @matcher = matcher
    @block = block
  end

  # if true, returns the matches, just for extra helpfulness :-)
  def respond_to_missing?(sym, args)
    matches = find_matches(sym)
    matches.any? ? matches : false
  end

  def method_missing(sym, *args, &blk)
    matches = find_matches(sym)
    if matches.any?
      @block.call(@object, matches, *args)
    else
      @object.send(sym, *args, &blk)
    end
  end

  private

  def find_matches(sym)
    result = @matcher.call(sym)
    result ? result : []
  end

end
