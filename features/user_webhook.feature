Feature: User webhook

  Scenario: Create new user
    When Puavo POST to "/webhook" using JSON
    """
    {"user":{"given_name":"Jane","surname":"Doe","uid":"jane.doe","email":"jane.doe@example.com","puavo_id":"654321"},"action":"create"}
    """
    Then I should see "User was successfully created"

  Scenario: Update user
    When Puavo POST to "/webhook" using JSON
    """
    {"user":{"given_name":"Jane","surname":"Doe","uid":"jane.doe","email":"jane.doe@example.com","puavo_id":"654321"},"action":"save"}
    """
    Then I should see "User was successfully created"
