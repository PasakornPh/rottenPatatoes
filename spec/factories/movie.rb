# spec/factories/movie.rb

FactoryGirl.define do
  factory :movie do
    id '1'
    title 'A Fake Title' # default values
    rating 'PG'
    release_date '2020-10-10'
  end
end