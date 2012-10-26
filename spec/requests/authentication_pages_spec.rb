require 'spec_helper'

describe "Authentication" do
  subject { page }
  
  describe "Sign in page" do
    before { visit signin_path }
    
    it { should have_selector 'h1',    text: 'Sign in' }
    it { should have_selector 'title', text: 'Sign in' }
  end

  describe "signin" do
    before { visit signin_path }    
    let(:submit) {'Sign in'}
    
    describe "with invalid information" do
      #it "should not login" do
      #  expect { click_button submit }.not_to change(Session, :count)      
      #end
      
      describe "after submission" do
        before { click_button submit }
        it { should have_selector 'title', text: full_title('Sign in') }
        it { should have_selector 'div.alert.alert-error', text: 'Invalid' }
        
        describe "after visiting another page" do
          before { click_link "Home" }
          it { should_not have_selector('div.alert.alert-error') }
        end
      end
    end
    
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button :submit
      end
      
      it { should     have_selector 'title',    text: user.name }
      it { should     have_link     'Profile',  href: user_path(user) }
      it { should     have_link     'Sign out', href: signout_path }
      it { should_not have_link     'Sign in',  href: signin_path }
    end
  end

  
end
