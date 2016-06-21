RSpec.describe User, type: :model do
    it { should validate_presence_of :username }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :power }
    it { should validate_uniqueness_of :username }
    it { should validate_uniqueness_of :email }
end