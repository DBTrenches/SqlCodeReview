# SqlCodeReview

The `SqlCodeReview` module provides a powershell one-liner for a developer to request a code review for production deployment. 

# Usage Requirements

* The developer must have `VIEW DEFINITION` permissions in both the source and target environments.
 * It is assumed that the developer has elevated permissions in a source/target environment and is not permitted to deploy objects to a target/production environment
* The developer must have permission to push to a GitHub or VSTS repository where a pull request will take place
 * Branch-level security may be applied so long as the developer has permission to create a new branch at the remote as well as push to a shared base branch

# Installation

If you just can't be bothered, invoke `install.ps1` in the root of this repo from an Administrator PS session. 

> **<u>STANDARD DISCLAIMER</u>:** If you're in the habit of executing code you found on the internet in an elevated shell without reading it, [you're gonna have a bad time][3]...

Otherwise, you'll need...

* to install [`SqlServer`][1] from the Powershell gallery
* clone or copy the [`SqlCreateTable`][2] module to a discoverable path (enumerated in `env:PsModulePath.Split(";")`)
* clone or copy this module to a discoverable path 
* add `Import-Module SqlCodeReview` to your profile if you please
 * prepare yourself for increased shell load times 
* 

----

<sup>
The solution is developed for SQL Server 2016/2017 and requires the `SqlServer` PS Module, which is incompatible with the earlier `SQLPS` module. Glhf resolving these conflicts ¯\\\_(ツ)_/¯ 
</sup>


[1]: https://docs.microsoft.com/en-us/sql/powershell/download-sql-server-ps-module
[2]: https://github.com/petervandivier/SqlCreateTable
[3]: https://youtu.be/6Ls5j5iz2eA
