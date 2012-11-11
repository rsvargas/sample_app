require 'spec_helper'

describe "Authentication" do
  subject { page }
  
  describe "Sign in page" do
    before { visit signin_path }
    
    it { should have_selector 'h1',    text: 'Sign in' }
    it { should have_selector 'title', text: 'Sign in' }
    it { should_not have_link 'Sign out' }
    it { should_not have_link 'Settings' }
    it { should_not have_link 'Profile' }
  end
  
  shared_examples_for 'a plain sign in' do
      it { should     have_selector 'title',    text: user.name }
      
      it { should     have_link     'Users',    href: users_path }
      it { should     have_link     'Profile',  href: user_path(user) }
      it { should     have_link     'Settings', href: edit_user_path(user) }
      it { should     have_link     'Sign out', href: signout_path }
      
      it { should_not have_link     'Sign in',  href: signin_path }
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
      before { sign_in user }

      it_should_behave_like 'a plain sign in'
    end
  end
  
  describe 'authorization' do
    
    describe 'for non-signed-in users' do
      let(:user) { FactoryGirl.create(:user) }
      
      describe 'when attempting to visit a protected page' do
        before do
          visit users_path
          sign_in user
        end
        
        describe 'after signing in' do
          it 'should render the desired protected page' do
            page.should have_selector 'title', text: 'All users'  
          end
        end
        
        describe 'after signing out' do
          before  { click_link 'Sign out' }
          
          describe 'and in again' do
            before { sign_in user }
            it_should_behave_like 'a plain sign in'
            it 'should have been redirected to the user profile' do
              page.should have_selector 'title', text: user.name
            end
          end
        end
      end
      
      describe 'in the Users controller' do
        
        describe 'visitting the edit page ' do
          before { visit edit_user_path(user) }
          it { should have_selector 'title', text: 'Sign in' }  
        end
        
        describe 'submitting to the update action' do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
        
        describe 'visitting the user index' do
          before { visit users_path }
          it { should have_selector 'title', text: 'Sign in' }
        end
      end
      
      describe 'as the wrong user' do
        let(:user) { FactoryGirl.create(:user) }
        let(:wrong_user) { FactoryGirl.create(:user, email: 'wrong@example.net' ) }
        before { sign_in user }
        
        describe 'visiting Users#edit page' do
          before {visit edit_user_path(wrong_user) }
          it { should_not have_selector('title', text: full_title('Edit User')) }
        end
        
        describe 'submitting a PUT request to the Users#update action' do
          before { put user_path(wrong_user) }
          specify { response.should redirect_to(root_path) }
        end
      end
      
      describe 'in the Microposts controller' do
        describe 'submitting to the create action' do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path)}
        end
        
        describe 'submitting to the destroy action' do
          before { delete micropost_path  FactoryGirl.create(:micropost) }
          specify { response.should redirect_to signin_path }
        end
      end
      
    end #end of non-signed-in users
    
    describe 'for signed-in users' do
      let(:user) { FactoryGirl.create(:user)}
      before { sign_in user }
      
      describe 'trying to create a new user' do
        describe 'accessing the Users#new action' do
          before { get new_user_path }
          specify { response.should redirect_to(root_path) }
        end
        
        describe 'POSTing to the Users#create action' do
          before { post users_path }
          specify { response.should redirect_to(root_path) }
        end
      end
      
    end
    
    describe 'as a non-admin user' do
      let(:user) { FactoryGirl.create(:user)}
      let(:non_admin) { FactoryGirl.create(:user)}
      
      before { sign_in non_admin}

      describe 'submitting a DELETE request to Users#destroy action' do
        before {delete user_path(user)}
        specify { response.should redirect_to(root_path)}
      end
    end
    
    describe 'as an admin user' do
      let(:admin) { FactoryGirl.create(:admin)}
      before { sign_in admin }
      describe 'submitting a DELETE request to destroy itself' do
        before {delete user_path(admin)}
        specify { response.should redirect_to(root_path)}
      end
    end
  end
  
end
