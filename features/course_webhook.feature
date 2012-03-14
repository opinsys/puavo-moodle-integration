Feature: User webhook

  Scenario: Create new course
    When Puavo POST to "/webhook" using JSON
    """
    {"course":{"name":"Mathematics","course_id":"MA9001","description":"Algebra","puavo_id":"223344"},"action":"create"}
    """
    Then I should see "Course was successfully created"
