require "spec_helper"

require "ib/parser"

describe IB::Parser do
  it "finds outlets and actions" do
    info = IB::Parser.new(:ios).find("spec/fixtures/common/custom_view.rb").first
    expect(info[:class]).to eql [["CustomView", "UIView"]]
    expect(info[:outlets]).to eql [
      ["greenLabel",    "UIGreenLabel"],
      ["redLabel",      "UILabel"],
      ["untyped_label", "id"],
      ["yellowLabel",   "id"]
    ]
    expect(info[:outlet_collections]).to eql [
      ["greenLabelCollection",     "UIGreenLabel"],
      ["redLabelCollection",       "UILabel"],
      ["untyped_label_collection", "id"],
      ["yellowLabelCollection",    "id"]
    ]
    expect(info[:actions]).to eql [
      ["someAction",              "sender",      nil],
      ["segueAction",             "sender",      "UIStoryboardSegue"],
      ["anotherAction",           "button",      nil],
      ["actionWithComment",       "sender",      nil],
      ["actionWithBrackets",      "sender",      nil],
      ["actionWithoutArgs",       nil,           nil],
      ["exitAction",              "story_board", nil],
      ["actionWithDefaultedArgs", "sender",      nil]
    ]
  end

  it "can parse complex superclasses" do
    info = IB::Parser.new(:ios).find("spec/fixtures/common/complex_superclass.rb")
    expect(info.first[:class]).to eql [["HasComplexSuperClass", "Complex::SuperClass"]]
    expect(info.last[:class]).to eql [["HasLessComplexSuperClass", "PM::Screen"]]
  end

  it "can output simple classes" do
    expect(IB::Parser.new(:ios).find("spec/fixtures/common/simple_class.rb").length).to eql 1
  end

  it "finds all infos" do
    infos = IB::Parser.new(:ios).find_all("spec/fixtures/dependency_test")
    infos.values.each do |vals|
      vals.each do |v|
        expect(v).to be_kind_of(IB::OCInterface)
      end
    end
  end

end
