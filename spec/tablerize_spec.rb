require 'spec_helper'

describe Tablerize do
  ['example-1', 'example-2'].each do |test_name|
    context test_name do
      reference_result = File.read "examples/#{test_name}.html"

      it "should be correctly converted via load_file" do
        test_result = Tablerize.load_file("examples/#{test_name}.yml").to_html
        expect(test_result.chomp).to eq(reference_result.chomp)
      end

      it "should be correctly converted via load" do
        test_result = Tablerize.load(File.read "examples/#{test_name}.yml").to_html
        expect(test_result.chomp).to eq(reference_result.chomp)
      end
    end
  end
end
