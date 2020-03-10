Feature: search for movies by director

  As a movie buff
  So that I can find movies with my favorite director
  I want to include and serach on director information in movies I enter

Background: movies in database

  Given the following movies exist:
  | title            | rating | director     | release_date |
  | Jurassic Park    | PG     | Steven Spielberg  |   1993-06-11 |
  | Titanic          | PG     | James Cameron     |   1997-12-19 |
  | Avatar           | R      |                   |   2009-12-18 |
  | Jaws             | R      | Steven Spielberg  |   2014-07-29 |

Scenario: add director to existing movie
  When I go to the edit page for "Avatar"
  And  I fill in "Director" with "James Cameron"
  And  I press "Update Movie Info"
  Then the director of "Avatar" should be "James Cameron"

Scenario: find movie with same director
  Given I am on the details page for "Jurassic Park"
  When  I follow "Find Movies With Same Director"
  Then  I should be on the Similar Movies page for "Jurassic Park"
  And   I should see "Jaws"
  But   I should not see "Titanic"

Scenario: can't find similar movies if we don't know director (sad path)
  Given I am on the details page for "Avatar"
  Then  I should not see "James Cameron"
  When  I follow "Find Movies With Same Director"
  Then  I should be on the home page
  And   I should see "'Avatar' has no director info"