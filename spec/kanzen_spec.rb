require_relative './../lib/kanzen'
require_relative 'active_record_helper'
require_relative 'models/application_record'
require_relative 'models/user'
require_relative 'models/address'
require_relative 'models/car'

incomplete_proc_user = User.create(name: "")
incomplete_user = User.create(name: nil)
complete_user = User.create(name: 'Charles Washington')
Address.create(city: 'Fortaleza', country: 'Brazil', user: complete_user)
Car.create(make: 'Honda', user: complete_user)
Car.create(make: 'Chevy', user: complete_user)

RSpec.describe Kanzen do
  it "has a version number" do
    expect(Kanzen::VERSION).not_to be nil
  end

  context 'with a COMPLETE model' do
    it '#completed? should return true' do
      expect(complete_user.completed?).to eq(true)
    end

    it '#percentage_present should return 100.0' do
      expect(complete_user.percentage_present).to eq(100.0)
    end

    it '#percentage_missing should return 0.0' do
      expect(complete_user.percentage_missing).to eq(0.0)
    end

    it '#present_attributes should contain expected keys' do
      expect(complete_user.present_attributes).to match("address" => ["city", "country", "user_id"],
                                                        "car" => ["make", "user_id", "make", "user_id"],
                                                        "user" => ["name"])
    end

    it '#missing_attributes should contain expected keys' do
      expect(complete_user.missing_attributes).to match({})
    end

    it '#number_of_present_attributes should equal to eight' do
      expect(complete_user.number_of_present_attributes).to match(8)
    end

    it '#number_of_missing_attributes should be zero' do
      expect(complete_user.number_of_missing_attributes).to match(0)
    end
  end

  context 'with an INCOMPLETE model' do
    it '#completed? should return false' do
      expect(incomplete_user.completed?).to eq(false)
    end

    it '#percentage_present should return 0.0' do
      expect(incomplete_user.percentage_present).to eq(0.0)
    end

    it '#percentage_missing should return 100.0' do
      expect(incomplete_user.percentage_missing).to eq(100.0)
    end

    it '#present_attributes should contain expected keys' do
      expect(incomplete_user.present_attributes).to match({})
    end

    it '#missing_attributes should contain expected keys' do
      expect(incomplete_user.missing_attributes).to match({"user" => ["name"]})
    end

    it '#number_of_present_attributes should equal to zero' do
      expect(incomplete_user.number_of_present_attributes).to match(0)
    end

    it '#number_of_missing_attributes should be one (id is present)' do
      expect(incomplete_user.number_of_missing_attributes).to match(1)
    end
  end

  context 'with a custom proc and an INCOMPLETE model' do
    custom_proc = Proc.new do |attribute_name, value, model|
      # If the value equals to "" or nil,
      # I think it is valid.
      if value == "" || value != nil
        true
      else
        false
      end
    end

    it '#completed? should return true' do
      expect(incomplete_proc_user.completed?(proc: custom_proc)).to eq(true)
    end

    it '#percentage_present should return 100.0' do
      expect(incomplete_proc_user.percentage_present(proc: custom_proc)).to eq(100.0)
    end

    it '#percentage_missing should return 0.0' do
      expect(incomplete_proc_user.percentage_missing(proc: custom_proc)).to eq(0.0)
    end

    it '#present_attributes should contain expected keys' do
      expect(incomplete_proc_user.present_attributes(proc: custom_proc)).to match("user" => ["name"])
    end

    it '#missing_attributes should contain expected keys' do
      expect(incomplete_proc_user.missing_attributes(proc: custom_proc)).to match({})
    end
  end
end
