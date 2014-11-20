require './hook_lying_syncer'

class Person
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

describe HookLyingSyncer do

  before do
    @person = Person.new("Dave")
    kinds_getter = ->(sym) {
      matches = /\Afind_(\w+)_widgets\Z/.match(sym)
      matches[1].split("_") if matches
    }
    @syncer = HookLyingSyncer.new(@person, kinds_getter) do |p, kinds, *args|
      addons = args.any? ? ", with #{args.join(" and ")}" : nil
      "#{p.name} wants #{kinds.join(" ")} widgets#{addons}"
    end
  end

  describe "respond_to_missing?" do

    it "can handle dynamically defined methods" do
      expect(@syncer.respond_to? :find_green_widgets).to equal true
    end

    it "can handle the original object's methods" do
      expect(@syncer.respond_to? :name).to equal true
    end

    it "still rejects unknown methods" do
      expect(@syncer.respond_to? :blargh).to equal false
    end

  end

  describe "method_missing" do

    describe "can handle dynamically defined methods" do

      it "with no args" do
        expect(@syncer.find_green_widgets).to eql "Dave wants green widgets"
      end

      it "with an arg" do
        expect(@syncer.find_green_widgets(:stripes)).to eql(
          "Dave wants green widgets, with stripes")
      end

      it "with multiple args" do
        expect(@syncer.find_green_widgets(:stripes, :spots)).to eql(
          "Dave wants green widgets, with stripes and spots")
      end

      it "with multiple subparts" do
        expect(@syncer.find_big_green_widgets).to eql(
          "Dave wants big green widgets")
      end

    end

    describe "can handle the object's original methods" do

      it "using the original object" do
        expect(@syncer.name).to eql "Dave"
      end

      it "even if the object-pointing var is changed" do
        @person = Person.new("Chris")
        expect(@person.name).to eql "Chris" # just a sanity check
        expect(@syncer.name).to eql "Dave"
      end

    end

    it "doesn't prevent blowup on totally unkown methods" do
      expect { @syncer.blarg }.to raise_error NoMethodError
    end

  end

  describe "with multiple levels" do

    before do
      name_getter = ->(sym) {
        matches = /\Asay_to_(\w+)\Z/.match(sym)
        matches[1].split("_and_").map(&:capitalize) if matches
      }
      @inner = @syncer
      @outer = HookLyingSyncer.new(@inner, name_getter) do |inner, names, *args|
        "#{inner.name} says \"#{args.join("\" and \"")}\" to #{names.join(" and ")}"
      end
    end

    describe "respond_to_missing?" do

      it "can handle dynamically defined methods" do
        expect(@person.respond_to? :say_to_fred).to equal false
        expect(@inner.respond_to? :say_to_fred).to equal false
        expect(@outer.respond_to? :say_to_fred).to equal true
      end

      it "can handle the original object's methods" do
        expect(@outer.respond_to? :name).to equal true
      end

      it "still rejects unknown methods" do
        expect(@outer.respond_to? :blargh).to equal false
      end

    end

    describe "method_missing" do

      it "can handle dynamically defined methods" do
        expect(@outer.say_to_fred_and_ethel("hail", "well met")).to eql(
          "Dave says \"hail\" and \"well met\" to Fred and Ethel")
      end

      it "can handle the inner object's methods" do
        expect(@outer.name).to eql "Dave"
      end

      it "can handle the inner syncer's methods" do
        expect(@outer.find_big_green_widgets(:stripes, :spots)).to eql(
          "Dave wants big green widgets, with stripes and spots")
      end

      it "still barfs on unknown methods" do
        expect { @outer.blarg }.to raise_error NoMethodError
      end

    end

  end

end
