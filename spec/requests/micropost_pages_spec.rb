require 'spec_helper'

describe "MicropostPages" do

  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  
  describe "micropost creation" do
    before { visit root_path }
    
    describe "with invalid information" do
      
      it "should not create a micropost" do
        expect { click_button "Post" }.should_not change(Micropost, :count)
      end
      
      describe "error messages" do
        before { click_button "Post" }
        it { should have_content("mistake") }
      end
    end
    describe "with valid information" do
      
      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.should change(Micropost, :count).by(1)
      end
    end
  end
  
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }
    
    describe "as correct user" do
      before { visit root_path }
      
      it "should delete a micropost" do
        expect { click_link "delete" }.should change(Micropost, :count).by(-1)
      end
    end
  end
  
  describe "from_users_followed_by" do
    
    let(:user)        { FactoryGirl.create(:user) }
    let(:other_user)  { FactoryGirl.create(:user) }
    let(:third_user)  { FactoryGirl.create(:user) }
    
    before { user.follow!(other_user) }
    
    let(:own_post)        { user.microposts.create!(content: "mrs.") }
    let(:followed_post)   { other_user.microposts.create!(content: "marissa") }
    let(:unfollowed_post) { third_user.microposts.create!(content: "chakraborty") }
    
    subject { Micropost.from_users_followed_by(user) }
    
    it { should include(own_post) }
    it { should include(followed_post) }
    it { should_not include(unfollowed_post) }
  end
end
