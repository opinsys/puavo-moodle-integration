Feature: User webhook

  Scenario: Create new user
    Given I am on the homepage
    When I POST to "/webhook" using JSON
    """
    {"user":{"given_name":"Jane","surname":"Doe","uid":"jane.doe","email":"jane.doe@example.com","puavo_id":"123456"}}
    """
    Then I should see "User was successfully created"