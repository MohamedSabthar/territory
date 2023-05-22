scriptsDir=/Users/mohamedsabthar/Desktop/gql-fork/module-ballerina-graphql/load-tests/book_reviews_subscription/scripts
resultsDir=/Users/mohamedsabthar/Desktop/gql-fork/module-ballerina-graphql/load-tests/book_reviews_subscription/results

# Run the test plan
jmeter -n -t "${scriptsDir}/"book-reviews-subscription-test-plan.jmx  -l "${resultsDir}/"original.jtl -Jusers=5 -JrampUpPeriod=100 -Jduration=300

# Post process
grep -E 'WS Next|label' "${resultsDir}/"original.jtl > "${resultsDir}/".temp.jtl
rm "${resultsDir}/"original.jtl
mv "${resultsDir}/".temp.jtl "${resultsDir}/"original.jtl

# Split the jtl file
/Users/mohamedsabthar/Desktop/sabthars-territory/automation/jmeter-utils/jtl-splitter.sh -- -f "${resultsDir}/"original.jtl -t 10 -u SECONDS -s

# Generate the report
/opt/homebrew/Cellar/jmeter/5.5/libexec/bin/JMeterPluginsCMD.sh --generate-csv temp_summary.csv --input-jtl "${resultsDir}/"original.jtl --plugin-type AggregateReport

# Generate the final csv
touch result.csv
/Users/mohamedsabthar/Desktop/sabthars-territory/automation/jmeter-utils/create-csv.sh temp_summary.csv result.csv 100 5

echo "########################################################################################"
cat result.csv
echo "########################################################################################"