Feature: Automatically scheduling tasks
  Background:
    Given I work from home
    And my day looks like this:
    | Task                       | Time             |
    | Sleep                      | Until 8:00 AM    |
    | Brush teeth                | 8:00 AM-8:15 AM  |
    | Doctor's appointment       | 3:45 PM-4:35 PM  |
    | Phone interview            | 4:45 PM-5:01 PM  |
    | Watch nature documentaries | 9:00 PM-10:00 PM |
    | Sleep                      | After 12:00 AM   |

  Scenario: Scheduling tasks
    When I schedule the following tasks:
    | Task                  | Timeframe        | Length     |
    | Eat breakfast         | 8:00 AM-9:00 AM  | 15 minutes |
    | Walk dog              | 8:00 AM-11:00 AM | 30 minutes |
    | Work on project       | 9:00 AM-12:00 PM | 1 hour     |
    | Work on project again | 12:00 PM-5:00 PM | 1 hour     |
    And I go to today's overview page
    Then I should see all of my appointments
    And I should see all of my tasks scheduled correctly

  Scenario: Scheduling impossible tasks
    When I schedule a set of tasks that is impossible
    And I go to today's overview page
    Then I should see an "Impossible Day" error page

  Scenario: Scheduling tasks that are too hard for SchedLogic to compute
    When I schedule a set of tasks that is too hard for SchedLogic
    And I go to today's overview page
    Then I should see a "Schedule Failure" error page
