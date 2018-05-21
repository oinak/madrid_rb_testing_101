require 'greeter' # test subject

RSpec.describe Greeter do
  describe "#say" do
    it "returns 'Hello Name!'" do
      greeter = Greeter.new("Ada")

      expect(greeter.say).to eq("Hello Ada!")
    end
  end
end
