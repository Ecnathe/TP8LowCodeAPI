@Smoke@TimeEntry
Feature: Time Entry

  Background:
    And base url https://api.clockify.me/api

  @getUserId
  Scenario: Get user Id
    Given endpoint /v1/user
    And header x-api-key = "YTFlNWYzOGUtODdkYS00NzI3LWJkZjYtNDM1ZDRiMTUyYmIx"
    When execute method GET
    Then the status code should be 200
    * define userId = $.id

  @findAllProjectsId
  Scenario: Get Projects Id
    Given call Project.feature@getAllWorkspaces
    And endpoint /v1/workspaces/{{idWorkspace}}/projects
    And header x-api-key = "YTFlNWYzOGUtODdkYS00NzI3LWJkZjYtNDM1ZDRiMTUyYmIx"
    When execute method GET
    Then the status code should be 200
    * define projectId = $.[0].id

  @getTimeEntriesForUsers @Do
    Scenario: Get all time entries for user
    Given call Project.feature@getAllWorkspaces
    Given call TimeEntry.feature@getUserId
    And endpoint /v1/workspaces/{{idWorkspace}}/user/{{userId}}/time-entries
    And header x-api-key = "YTFlNWYzOGUtODdkYS00NzI3LWJkZjYtNDM1ZDRiMTUyYmIx"
    When execute method GET
    Then the status code should be 200

  @addNeTimeEntry
  Scenario: Add hours to a project
    Given call TimeEntry.feature@findAllProjectsId
    And endpoint /v1/workspaces/{{idWorkspace}}/time-entries
    And header x-api-key = "YTFlNWYzOGUtODdkYS00NzI3LWJkZjYtNDM1ZDRiMTUyYmIx"
    And header Content-Type = "application/json"
    And set value {{projectId}} of key projectId in body jsons/bodies/addTimeEntry.json
    And set value 2025-06-13T19:02:00Z of key start in body jsons/bodies/addTimeEntry.json
    And set value 2025-06-14T17:08:00Z of key end in body jsons/bodies/addTimeEntry.json
    When execute method POST
    Then the status code should be 201
