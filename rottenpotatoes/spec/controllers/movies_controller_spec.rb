require 'rails_helper'
describe MoviesController do
  before(:each) do
    @movie1 = FactoryBot.create(:movie, id: 11, title: "The Hostel", rating: "UG", description: "", release_date: "2012", director: "Unkown")
    @movie2 = FactoryBot.create(:movie, id: 12, title: "Avatar", rating: "PG", description: "", release_date: "2006", director: "Unkown")
    @movie3 = FactoryBot.create(:movie, id: 13, title: "The wings of fire", rating: "R", description: "Check if it works", release_date: "4566")
  end

  describe 'preexisting method test in before(:each)' do
    it 'should call find model method' do
      Movie.should_receive(:find).with('1')
      get :show, :id => '1'
    end

    it 'should render page correctoy' do
      get :index
      response.should render_template :index
    end

    it 'should redirect to appropriate url' do
      get :index,
          {},
          {ratings: {G: 'G', PG: 'PG'}}
      response.should redirect_to :ratings => {G: 'G', PG: 'PG'}
    end

    it 'should redirect to appropriate sort title url' do
      get :index,
          {},
          {sort: 'title'}
      response.should redirect_to :sort => 'title'
    end

    it 'should redirect to appropriate sort release_date url' do
      get :index,
          {},
          {sort: 'release_date'}
      response.should redirect_to :sort => 'release_date'
    end

    it 'should create movie and redirect' do
      post :create,
           {:movie => { :title => "Golmaal", :description => "A comedy movie", :director => "Rohit Shetty", :rating => "R", :release_date =>"02/08/2006"}}
      response.should redirect_to movies_path
      expect(flash[:notice]).to be_present

    end
    it 'should render two movies' do
      get :index
      response.should render_template :index
    end

    it 'should update render edit view' do
      Movie.should_receive(:find).with('1')
      get :edit,
          {id: '1'}

    end

    it 'should update data correctly' do
      Movie.stub(:find).and_return(@movie1)
      put :update,
          :id => @movie1[:id],
          :movie => {title: "Another Movie", rating: "UG", description: "Horror movie", release_date: "25/11/2066", director: "Rohit Shetty"}
      expect(flash[:notice]).to be_present
    end
  end

  describe 'director methods test in before(:each)' do
    it 'should call appropriate model method' do
      Movie.should_receive(:same_movies).with(@movie2[:id], {'director' => @movie2[:director]})
      get :same, :id => @movie2[:id], :by_dir => 'director'
    end

    it 'should redirect to homepage on invalid no director request' do
      Movie.should_receive(:same_movies).with(@movie3[:id], {'director' => @movie3[:director]})
      Movie.stub(:same_movies).with(@movie3[:id], {'director' => @movie3[:director]}).and_return(nil)
      get :same, :id => @movie3[:id], :by_dir => 'director'
      expect(flash[:notice]).to be_present
      response.should redirect_to movies_path
    end
  end
end
