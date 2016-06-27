RSpec.describe Game, type: :model do
    it { should belong_to :user }
    it { should have_many :figures }
    it { should validate_presence_of :user_id }
end
