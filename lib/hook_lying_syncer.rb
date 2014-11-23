require "hook_lying_syncer/version"

class HookLyingSyncer

  # object is the object being wrapped, for purposes of endowing it with some
  # pattern of methods it should respond to.
  #
  # matcher is a lambda that returns any words of interest to the block, given
  # the called method name.  if there are any, it should return an array.  if
  # there are none, it may return an empty array, nil, or false, and the method
  # name will be ass-u-me'd to be "not of interest".
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

  private

  def respond_to_missing?(sym, include_all=false)
    matches = find_matches(sym)
    matches.any? ? true : @object.send(:respond_to?, sym, include_all)
  end

  def method_missing(sym, *args, &blk)
    matches = find_matches(sym)
    if matches.any?
      @block.call(@object, matches, *args)
    else
      @object.send(sym, *args, &blk)
    end
  end

  def find_matches(sym)
    result = @matcher.call(sym)
    result ? result : []
  end

end
