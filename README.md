# SqlCodeReview

The `SqlCodeReview` module provides a powershell one-liner for a developer to request a code review for production deployment. 

# Usage 

## Example

```powershell
$objectsToReview = @(
    "AdventureWorks.Person.Person",
    "WorldWideImporters.InMemory.Insert50ThousandVehicleLocations"
)
Request-DBCodeReview $objectsToReview
```

The above script will launch a chrome session to your repo where you can submit a pull request comparing the differences between the two named objects in you _prod_ and _qa_ environments. 

Provide a comma-separated list of 3-part-qualified database objects. These objects will be written to disk from the _prod_ and _qa_ environments defined in your default config. 

## Requirements

* The developer must have `VIEW DEFINITION` permissions in both the source and target environments.
    * It is assumed that the developer has elevated permissions in a source/target environment and is not permitted to deploy objects to a target/production environment
* The developer must have permission to push to a GitHub or VSTS repository where a pull request will take place
    * Branch-level security may be applied so long as the developer has permission to create a new branch at the remote as well as push to a shared base branch
