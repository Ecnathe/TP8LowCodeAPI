@Smoke
Feature: Project

  Background:
    And base url https://api.clockify.me/api

  @getAllWorkspacesNoOk
  Scenario: Get All My Workspaces - No Ok
    Given endpoint /v1/workspaces
    And header x-api-key = ""
    When execute method GET
    Then the status code should be 401
    And response should be $.message = "Api key does not exist"

  @getAllWorkspaces
  Scenario: Get All My Workspaces - Ok
    Given endpoint /v1/workspaces
    And header x-api-key = "M2NjMzczOWUtMWFiMi00NWU3LTlmMGYtMThkM2JiOTJmMDNi"
    When execute method GET
    Then the status code should be 200
    And response should be $.[0].name = "EdicionPrueba1"
    And response should be $.[0].hourlyRate.currency = "USD"
    And response should be $.[0].memberships.[0].userId = "67fed65cda507d1b668188f5"
    * define idWorkspace = $.[0].id

  @getWorkspaceInfoWithoutCall
  Scenario: Get Workspace Info - No step call
    Given endpoint /v1/workspaces
    And header x-api-key = "M2NjMzczOWUtMWFiMi00NWU3LTlmMGYtMThkM2JiOTJmMDNi"
    And execute method GET
    * define idWorkspace = $.[1].id
    And base url https://api.clockify.me/api
    And endpoint /v1/workspaces/{{idWorkspace}}
    And header x-api-key = "M2NjMzczOWUtMWFiMi00NWU3LTlmMGYtMThkM2JiOTJmMDNi"
    When execute method GET
    Then the status code should be 200
    And response should be $.name = "addedwithpostman"

  @getWorkspaceInfoWithCall
  Scenario: Get Workspace Info - Step call
    Given call Clockify.feature@getAllWorkspaces
    And endpoint /v1/workspaces/{{idWorkspace}}
    And header x-api-key = "M2NjMzczOWUtMWFiMi00NWU3LTlmMGYtMThkM2JiOTJmMDNi"
    When execute method GET
    Then the status code should be 200
    And response should be $.name = "myworkspace"

  Scenario Outline: Add a New Client
    Given call Clockify.feature@getAllWorkspaces
    And endpoint /v1/workspaces/{{idWorkspace}}/clients
    And header x-api-key = "M2NjMzczOWUtMWFiMi00NWU3LTlmMGYtMThkM2JiOTJmMDNi"
    And header Content-Type = "application/json"
    And set value <name> of key name in body jsons/bodies/addNewClient.json
    When execute method POST
    Then the status code should be 201
    And response should be $.name = <name>
    Examples:
      | name      |
      | "client1" |
      | "client2" |
      | "client3" |

  @addNewClient
  Scenario Outline: Add a New Client
    Given call Clockify.feature@getAllWorkspaces
    And endpoint /v1/workspaces/{{idWorkspace}}/clients
    And header x-api-key = "M2NjMzczOWUtMWFiMi00NWU3LTlmMGYtMThkM2JiOTJmMDNi"
    And header Content-Type = "application/json"
    And set value <name> of key name in body jsons/bodies/addNewClient.json
    When execute method POST
    Then the status code should be 201
    And response should be $.name = <name>
    * define idClient = $.id
    Examples:
      | name      |
      | "crowdar" |

  @getClientById
  Scenario: Get Client y Id
    Given call Clockify.feature@addNewClient
    And endpoint /v1/workspaces/{{idWorkspace}}/clients/{{idClient}}
    And header x-api-key = "M2NjMzczOWUtMWFiMi00NWU3LTlmMGYtMThkM2JiOTJmMDNi"
    When execute method GET
    Then the status code should be 200
    And response should be $.id = {{idClient}}

  @deleteClient
  Scenario: Delete client
    Given call Clockify.feature@getClientById
    And endpoint /v1/workspaces/{{idWorkspace}}/clients/{{idClient}}
    And header x-api-key = $(env.xApiKey)
    When execute method DELETE
    Then the status code should be 200