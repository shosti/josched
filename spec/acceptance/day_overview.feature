Feature: Day overview
  Background:
    Given I work from home
    And my day looks like this:
    | Task                       | Time             |
    | Sleep                      | Until 8:00 AM    |
    | Brush teeth                | 8:00 AM-8:15 AM  |
    | Eat breakfast              | 8:15 AM-8:45 AM  |
    | Work                       | 9:00 AM-5:00 PM  |
    | Eat dinner                 | 6:30 PM-7:00 PM  |
    | Watch nature documentaries | 9:00 PM-10:00 PM |
    | Sleep                      | After 12:00 AM   |

  Scenario: An overview of my day
    When I go to today's overview page
    Then I should see all of my tasks
    And I should see the following free times:
    | time              |
    | 5:00 PM-6:30 PM   |
    | 7:00 PM-9:00 PM   |
    | 10:00 PM-12:00 AM |
