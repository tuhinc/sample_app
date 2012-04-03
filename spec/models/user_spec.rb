require 'spec_helper'

describe User do
  
  #create a valid user
  
  before do
    @user = User.new(name: "Example User", email: "user@example.com", 
                      password: "foobar", password_confirmation: "foobar")  
  end
  
  #make sure the following tests have our new user as their subject
  subject { @user }
  
  #check that you can run the following methods on @user
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token)}
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  
  #sanity-check => check that the user is valid
  it { should be_valid }
  it { should_not be_admin }
  
  describe "with admin attribute set to 'true'" do
    before { @user.toggle!(:admin) }
    
    it { should be_admin }
  end
  
  #create an instance of the user that should violate validity
  #then make sure the user model finds it invalid
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  
  #create an instance of the user that should violate validity
  #then make sure the user model finds it invalid
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  #create an instance of the user that should violate validity
  #then make sure the user model finds it invalid
  describe "when name is way too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  #create an instance of a user with invalid email
  #then make sure the user model finds it invalid
  describe "when email format is invalid" do
    invalid_addresses = %w[user@foo,com user_at_foo.org t@t.t example.user@foo]
    invalid_addresses.each do |invalid_address|
      before { @user.email = invalid_address }
      it { should_not be_valid }
    end
  end
  
  #create an instance of a user with valid email
  #then make sure the user model finds it valid
  describe "when email format is valid" do
    valid_addresses = %w[tuhin@gmail.com A_T@tuh.three.org first.last@zn.cn]
    valid_addresses.each do |valid_address|
      before { @user.email = valid_address }
      it { should be_valid }
    end
  end
  
  #create a user with the same email address as @user
  #make it uppercase to ensure case sensitivity is not an issue
  #save the new user and make sure it is not valid
  describe "when email address is already def taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    
    it { should_not be_valid }
  end
  
  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end
  
  describe "when password does not match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end
  
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }
    
    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end
    
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      
      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
  
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end