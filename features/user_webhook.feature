Feature: User webhook

  Scenario: Create new user
    When Puavo POST to "/webhook" using JSON
    """
    {"user":{"given_name":"Jane","surname":"Doe","uid":"jane.doe","email":"jane.doe@example.net","puavo_id":"654321"},"action":"create"}
    """
    Then I should see "User was successfully created"

  Scenario: Update user
    When Puavo POST to "/webhook" using JSON
    """
    {"user":{"given_name":"Jane","surname":"Doe","uid":"jane.doe","email":"jane.doe@example.net","puavo_id":"654321"},"action":"create"}
    """
    Then I should see "User was successfully created"
    When Puavo POST to "/webhook" using JSON
    """
    {"user":{"given_name":"JaneEDIT","surname":"DoeEDIT","uid":"jane.doe","email":"jane.doe@example.net","puavo_id":"654321"},"action":"update"}
    """
    Then I should see "User was successfully updated"

  Scenario: Delete user
    When Puavo POST to "/webhook" using JSON
    """
    {"user":{"given_name":"Jane","surname":"Doe","uid":"jane.doe","email":"jane.doe@example.net","puavo_id":"654321"},"action":"create"}
    """
    Then I should see "User was successfully created"
    When Puavo POST to "/webhook" using JSON
    """
    {"user":{"given_name":"Jane","surname":"Doe","uid":"jane.doe","email":"jane.doe@example.net","puavo_id":"654321"},"action":"destroy"}
    """
    Then I should see "User was successfully deleted"
   
  Scenario: Create user with wrong private api key
    When Puavo POST to "/webhook" using JSON with wrong private api key
    """
    {"user":{"given_name":"Jane","surname":"Doe","uid":"jane.doe","email":"jane.doe@example.net","puavo_id":"654321"},"action":"create"}
    """
    Then I should see "Authentication failed"
    And I should not see "User was successfully created"

