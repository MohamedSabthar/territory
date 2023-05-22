# graphql module test listeners ports
echo "🥷  I'm a graphql port killer 🥷"

PORTS=(4040 9445 9089 9090 9091 9092 9093 9094 9095 9095 9097 9098 9099 9190 9191)
PIDS=()

# get process ids of ports
for port in "${PORTS[@]}" 
do
    var=$(exec lsof -i tcp:"${port}" | awk 'NR==2 { print $2 }')
    if [ $port!="" ]
    then
        PIDS+=("${var}")
    fi
done

# filter unique process ids
PIDS=($(echo "${PIDS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

# kill processes by ids
for pid in "${PIDS[@]}" 
do
    echo "🔪 killing: ${pid} 🩸"
    kill -9 "${pid}"
done

echo "🔥 Killed all graphql port(s) 🔥"