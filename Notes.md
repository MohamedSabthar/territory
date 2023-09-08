Use the packages from stage central
- BALLERINA_STAGE_CENTRAL=true bal build

Debug with bal java
- BAL_JAVA_DEBUG=5005 bal run

Ballerina debug
- bal run --debug 5005 pipe.bal

Updating the RC/Release dependencies
- update the dependency versions
- if module/dependencies includes breaking changes due to lang 
  - update lang version
  - bump minor version of the module
  - update the distribution version in Ballerina.toml

- if there is a dependency with a bump; bump the minor version of the module