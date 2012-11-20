require 'spec_helper'

describe "Micropost pages" do
  subject { page }
  
  let(:user) { FactoryGirl.create :user }
  let(:post) {'Post'}
  before { sign_in user }
  
  describe 'micropost creation' do
    before { visit root_path }
    
    describe 'with invalid information' do
      it 'should not create a micropost' do
        expect { click_button post }.not_to change(Micropost, :count)
      end
      
      describe 'error messages' do
        before { click_button post }
        it { should have_content('error') }
        
      end
    end
    
    describe 'with valid information' do
      before { fill_in 'micropost_content', with: 'Lorem Ipsum' }
      it 'should create a micropost' do
        expect { click_button post }.to change(Micropost, :count).by(1)
      end
    end
  end #micropost creation
  
  describe 'micropost destruction' do
    before { FactoryGirl.create(:micropost, user: user )}
    
    describe 'as correct user' do
       before { visit root_path }
       
       it 'should delete a micropost' do
         expect { click_link 'delete' }.to change(Micropost, :count).by(-1)
       end
    end
  end
   
end
