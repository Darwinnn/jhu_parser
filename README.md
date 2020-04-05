# What it is
As I was in self-isolation, I decided to learn [Crystal language](https://crystal-lang.org/) 

So I built this parser, which takes data from the [John Hopkins University github repo](https://github.com/CSSEGISandData/COVID-19), parses the csv files and exposes a JSON API

The app is deployed to Heroku, and you can access it here: https://jhu-parser.herokuapp.com/

# Build
```bash
shards build
```

# Run
```bash
bin/main 
```

# Usage
App accepts GET requests on port 3000 and support these routes:
1. `GET /` - return data for all countries
2. `GET /total` - return total stats
3. `GET /:country` - return per country stats


## Data structure
* `total` - represents latest data
* `diff` - increase in the last 24hrs (today-yesterday)

```json
{
    "recovered": {
        "total": 246152,
        "diff": 20356
    },
    "confirmed": {
        "total": 1197405,
        "diff": 101488
    },
    "dead": {
        "total": 64606,
        "diff": 5819
    }
}
```
