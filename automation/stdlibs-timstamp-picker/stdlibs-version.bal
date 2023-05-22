import ballerina/graphql;
import ballerina/io;
import ballerina/os;

configurable string PAT = os:getEnv("readPackagePAT");

final string[] stdlibs = [
    "io.ballerina.stdlib.constraint-ballerina",
    "io.ballerina.stdlib.io-ballerina",
    "io.ballerina.stdlib.jballerina.java.arrays-ballerina",
    "io.ballerina.stdlib.regex-ballerina",
    "io.ballerina.stdlib.time-ballerina",
    "io.ballerina.stdlib.url-ballerina",
    "io.ballerina.stdlib.xmldata-ballerina",
    "io.ballerina.stdlib.crypto-ballerina",
    "io.ballerina.stdlib.log-ballerina",
    "io.ballerina.stdlib.os-ballerina",
    "io.ballerina.stdlib.protobuf-ballerina",
    "io.ballerina.stdlib.random-ballerina",
    "io.ballerina.stdlib.serdes-ballerina",
    "io.ballerina.stdlib.task-ballerina",
    "io.ballerina.stdlib.xslt-ballerina",
    "io.ballerina.stdlib.cache-ballerina",
    "io.ballerina.stdlib.file-ballerina",
    "io.ballerina.stdlib.ftp-ballerina",
    "io.ballerina.stdlib.mime-ballerina",
    "io.ballerina.stdlib.tcp-ballerina",
    "io.ballerina.stdlib.udp-ballerina",
    "io.ballerina.stdlib.stan-ballerina",
    "io.ballerina.stdlib.nats-ballerina",
    "io.ballerina.stdlib.uuid-ballerina",
    "io.ballerina.stdlib.auth-ballerina",
    "io.ballerina.stdlib.email-ballerina",
    "io.ballerina.stdlib.jwt-ballerina",
    "io.ballerina.stdlib.oauth2-ballerina",
    "io.ballerina.stdlib.http-ballerina",
    "io.ballerina.stdlib.grpc-ballerina",
    "io.ballerina.stdlib.websocket-ballerina",
    "io.ballerina.stdlib.websub-ballerina",
    "io.ballerina.stdlib.websubhub-ballerina",
    "io.ballerina.stdlib.graphql-ballerina",
    "io.ballerina.stdlib.kafka-ballerina",
    "io.ballerina.stdlib.rabbitmq-ballerina",
    "io.ballerina.stdlib.sql-ballerina",
    "io.ballerina.stdlib.persist-ballerina",
    "io.ballerina.stdlib.mysql-ballerina",
    "io.ballerina.stdlib.java.jdbc-ballerina",
    "io.ballerina.stdlib.mssql-ballerina",
    "io.ballerina.stdlib.postgresql-ballerina",
    "io.ballerina.stdlib.oracledb-ballerina"
];

string document = string
    `query ($names: [String]) {
        organization(login: "ballerina-platform") {
            name
            packages(names: $names, first: 45) {
                nodes {
                    name
                    latestVersion {
                        version
                    }
                }
            }
        }
    }`;

type StdLibs record {
    record {
        record {
            string name;
            record {
                record {
                    string name;
                    record {
                        string 'version;
                    } latestVersion;
                }[] nodes;
            } packages;
        } organization;
    } data;
};

public function main() returns error? {
    graphql:Client gh = check new ("https://api.github.com/graphql");
    map<json> variables = {"names": stdlibs};
    map<string[]> versions = {};
    foreach var lib in stdlibs {
        versions[lib] = [];
    }
    StdLibs result = check gh->execute(document, variables, headers = {"Authorization": string `bearer ${PAT}`});
    foreach var package in result.data.organization.packages.nodes {
        string name = package.name.substring("io.ballerina.stdlib.".length());
        name = name.substring(0, <int>name.lastIndexOf("-"));
        versions[package.name] = [name, package.latestVersion.'version];
    }
    foreach var lib in stdlibs {
        io:println(versions.get(lib)[1], "\t", versions.get(lib)[0]);
    }
    check io:fileWriteCsv("stdlib.csv", versions.toArray());
}
