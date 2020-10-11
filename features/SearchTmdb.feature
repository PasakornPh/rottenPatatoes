Feature: User can search movie on Tmdb.

    Scenario: Search movie
        Given I am on the RottenPotatoes home page
        Then I should see "RottenPotatoes"
        And I should see "Search TMDb for a movie"
        When I fill in "Search Terms" with "About Time"
        And I press "Search TMDb"
        Then I should be on the Search TMDb page
        And I should see "Search Results"
        And I should see "About Time"
        
        
