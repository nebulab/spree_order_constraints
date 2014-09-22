RSpec::Matchers.define :eq_to_time do |another_date|
  match do |a_date|
    expect(a_date.to_i).to eq another_date.to_i
  end
end
