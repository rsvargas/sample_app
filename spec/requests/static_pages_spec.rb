require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  
  subject { page }
  
  it "should have the right links in the layout" do
    visit root_path
    click_link "About"
    should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    should have_selector 'title', text: full_title('Contact')
    click_link "Sign in"
    should have_selector 'title', text: full_title('Sign in')
    click_link "Home"
    click_link "Sign up now!"
    should have_selector 'title', text: full_title('Sign up')
    click_link "sample app"
    should have_selector 'title', text: full_title('')
  end
  
  shared_examples_for "all static pages" do
    it { should have_selector 'h1',    text: heading }
    it { should have_selector 'title', text: full_title(page_title) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) {'Sample App'}
    let(:page_title) {''}
    
    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: "| Home" }
    
    describe 'for signed in users' do
      let(:user) { FactoryGirl.create(:user)}
      
      
      describe "user feed" do
        before(:all) { 50.times { FactoryGirl.create(:micropost, user: user ) } }
        after(:all) { user.microposts.delete_all }
        
        before(:each) do
          sign_in user
          visit root_path
        end
        
        it 'should have the correct micropost count' do
          text = "#{user.microposts.count} micropost"
          text += 's' if user.microposts.count != 1
          should have_content(text)
        end
  
        it { should have_selector 'div.pagination' }
  
        it 'should be paginated correctly' do
          user.feed.paginate(page: 1).each do |item|
            page.should have_selector("li##{item.id}", text: item.content)
          end
        end
    end
      
    end
  end
  
  describe "Help page" do
    before { visit help_path }
    let(:heading) {'Help'}
    let(:page_title) {'Help'}
    
    it_should_behave_like "all static pages"
  end
  
  describe "About page" do
    before { visit about_path }
    let(:heading) {'About Us'}
    let(:page_title) {'About Us'}
    
    it_should_behave_like "all static pages"
  end
  
  describe "Contact page" do
    before { visit contact_path }
    let(:heading) {'Contact'}
    let(:page_title) {'Contact'}
    
    it_should_behave_like "all static pages"
  end
end
