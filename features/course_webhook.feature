Feature: Course webhook

  Scenario: Create new course
    When Puavo POST to "/webhook" using JSON
    """
    {"course":{"name":"Mathematics","course_id":"MA9001","description":"Algebra","puavo_id":"223344"},"action":"create","organisation":"example"}
    """
    Then I should see "Course was successfully created"

#  Course update is not implemented: Moodle 2.2.2 (Build: 20120312)
#
#  Scenario: Update course
#    When Puavo POST to "/webhook" using JSON
#    """
#    {"course":{"name":"Mathematics","course_id":"MA9001","description":"Algebra","puavo_id":"223344"},"action":"create"}
#    """
#    Then I should see "Course was successfully created"
#    When Puavo POST to "/webhook" using JSON
#    """
#    {"course":{"name":"MathematicsEDIT","course_id":"MA9001EDIT","description":"AlgebraEDIT","puavo_id":"223344"},"action":"save"}
#    """
#    Then I should see "Course was successfully updated"
    
