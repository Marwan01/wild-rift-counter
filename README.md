# wild-rift-counter

## Approach:
1. create a python script that will create a json that contains all the
   champions and their counters. Example:
{
   "Aatrox":["Elise", "Akali"],
   "Akali":["Morgana", "Blitz"],
 ...
}

2. clean up data to match WR (subset of LoL)
WR = subset(LoL). Example:
all_champions(LoL) = 250
all_champions(WR) = 100

3. add script result to s3

4. add script to be ran in a lambda, using terraform

5. create a lambda with parameter that will query the s3 object to get wanted
   counter result

6. make that available to be used in serverless app (web app, cli etc...)
