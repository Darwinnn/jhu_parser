# Build
```bash
shards build
```

# Run
```bash
bin/JHUParser 
```

# Usage
App accepts GET requests on port 3000 and support these routes:
1. `GET /` - return data for all countries
2. `GET /total` - return total stats
3. `GET /:country` - return per country stats

## Examples
```bash
$ curl localhost:3000/US
{"confirmed":[275586,243453],"dead":[7087,5926],"recovered":[9707,9001]}

$ curl localhost:3000/total
{"confirmed":[1095917,1013157],"recovered":[225796,210263],"dead":[58787,52983]}
```

### Data structure
{"confirmed":[`today`,`yesterday`],"recovered":[`today`,`yesterday`],"dead":[`today`,`yesterday`]}
