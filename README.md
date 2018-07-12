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

# Installation

## Basic Installation

If you _just can't be bothered_, invoke `install.ps1` in the root of this repo from an Administrator PS session. 

> **<u>STANDARD DISCLAIMER</u>:** If you're in the habit of executing code you found on the internet in an elevated shell without reading it, [you're gonna have a bad time][3]...

## Advanced Installation

Otherwise, you'll need to...

* install [`SqlServer`][1] from the Powershell gallery
    * note in the above link, you  will need to forcibly remove the `SQLPS` module if it is installed. a reboot may be required
* clone or copy the [`SqlCreateTable`][2] module to a discoverable path (enumerated in `env:PsModulePath.Split(";")`)
* clone or copy this module to a discoverable path 
* add `Import-Module SqlCodeReview` to your profile if you please
    * prepare yourself for increased shell load times 
* Validate the required config files (2 are required)
    * a `json` file that identifies directory location & format style of the git repo you'll be using
    * a `csv` file describing server addresses for different environments by database in your infrastructure

----

<sup>
The solution is developed for SQL Server 2016/2017 and requires the `SqlServer` PS Module, which is incompatible with the earlier `SQLPS` module. Glhf resolving these conflicts ¯\_(ツ)_/¯ 
</sup>


[1]: https://docs.microsoft.com/en-us/sql/powershell/download-sql-server-ps-module
[2]: https://github.com/petervandivier/SqlCreateTable
[3]: https://youtu.be/6Ls5j5iz2eA
