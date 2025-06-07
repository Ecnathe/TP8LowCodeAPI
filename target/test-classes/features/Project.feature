@Smoke
Feature: Project

  Background:
    And base url https://api.clockify.me/api

  @getAllWorkspaces
  Scenario: Get All My Workspaces - Ok
    Given endpoint /v1/workspaces
    And header x-api-key = "YTFlNWYzOGUtODdkYS00NzI3LWJkZjYtNDM1ZDRiMTUyYmIx"
    When execute method GET
    Then the status code should be 200
    And response should be $.[0].name = "EdicionPrueba1"
    * define idWorkspace = $.[0].id

  @addNewClient
  Scenario Outline: Add a New Client
    Given call Project.feature@getAllWorkspaces
    And endpoint /v1/workspaces/{{idWorkspace}}/clients
    And header x-api-key = "YTFlNWYzOGUtODdkYS00NzI3LWJkZjYtNDM1ZDRiMTUyYmIx"
    And header Content-Type = "application/json"
    And set value <name> of key name in body jsons/bodies/addNewClient.json
    When execute method POST
    Then the status code should be 201
    And response should be $.name = <name>
    * define idClient = $.id
    Examples:
      | name              |
      | "Robertito Funes" |


  @getClientById
  Scenario: Get Client by Id
    Given call Project.feature@addNewClient
    And endpoint /v1/workspaces/{{idWorkspace}}/clients/{{idClient}}
    And header x-api-key = "YTFlNWYzOGUtODdkYS00NzI3LWJkZjYtNDM1ZDRiMTUyYmIx"
    When execute method GET
    Then the status code should be 200
    And response should be $.id = {{idClient}}

  @addNewProject
  Scenario Outline: Add New Project
    Given call Project.feature@getClientById
    And endpoint /v1/workspaces/{{idWorkspace}}/projects
    And header x-api-key = "YTFlNWYzOGUtODdkYS00NzI3LWJkZjYtNDM1ZDRiMTUyYmIx"
    And header Content-Type = "application/json"
    And set value <name> of key name in body jsons/bodies/addNewProject.json
    And set value {{idClient}} of key clientId in body jsons/bodies/addNewProject.json
    When execute method POST
    Then the status code should be 201
    And response should be $.name = <name>
    * define projectId = $.id
    Examples:
      | name                |
      | "PryectoDePrueba01" |

  @findProjectById
  Scenario: Get Project By Id
    Given call Project.feature@addNewProject
    And endpoint /v1/workspaces/{{idWorkspace}}/projects/{{projectId}}
    And header x-api-key = "YTFlNWYzOGUtODdkYS00NzI3LWJkZjYtNDM1ZDRiMTUyYmIx"
    When execute method GET
    Then the status code should be 200
    And response should be $.id = {{projectId}}

  @updateProject
  Scenario Outline: Update Project
    Given call Project.feature@findProjectById
    And endpoint /v1/workspaces/{{idWorkspace}}/projects/{{projectId}}
    And header x-api-key = "YTFlNWYzOGUtODdkYS00NzI3LWJkZjYtNDM1ZDRiMTUyYmIx"
    And header Content-Type = "application/json"
    And set value <projectName> of key name in body jsons/bodies/updateProject.json
    When execute method PUT
    Then the status code should be 200
    And response should be $.name = <projectName>
    Examples:
      | projectName        |
      | Mirá como te edito |

  @projectNotFound @Error
  Scenario: Project Not Found
    Given endpoint /v1/workspaces/idWorkspace/project/1
    And header x-api-key = "YTFlNWYzOGUtODdkYS00NzI3LWJkZjYtNDM1ZDRiMTUyYmIx"
    And header Content-Type = "application/json"
    When execute method GET
    Then the status code should be 404

 @badRequest @Error
  Scenario: Bad Request
    Given call Project.feature@getAllWorkspaces
    Given endpoint /v1/workspaces/{{idWorkspace}}/projects/1
    And header x-api-key = "YTFlNWYzOGUtODdkYS00NzI3LWJkZjYtNDM1ZDRiMTUyYmIx"
    And header Content-Type = "application/json"
    When execute method GET
    Then the status code should be 400

  @Unauthorized @Error @Do
  Scenario: Unauthorized
    Given endpoint /v1/workspaces/idWorkspace/project/
    And header x-api-key = "YTFlNWYzOGUtODdkYS00NzI3LWJkZjYtNDM1ZDRiMTUyYmI"
    And header Content-Type = "application/json"
    When execute method GET
    Then the status code should be 401











