## Commands to Run on Server

```shell
sudo docker build -t postgresql .

sudo docker build -t app .

sudo docker run -d -p 10001:5432 -v ~/logs/postgres:/var/log -v ~/postgres-data:/var/lib/postgresql/data --name db postgresql

sudo docker run -d -v ~/logs/app:/var/log --name app --link db:postgres app
```

## Connecting to Server

```shell
psql -U postgres -h 54.187.57.174 -p 10001
```

### Database Table Size

```sql
SELECT relname, reltuples, relpages * 8 / 1024 AS "MB" FROM pg_class ORDER BY relpages DESC LIMIT 10;
```

## Selected Screen Names

### Sports

NBA,Cristiano,TwitterSports,KDTrey5,carmeloanthony,KingJames,espn,nfl,RafaelNadal,BillSimmons,SportsCenter,SHAQ

### Music

shakira,rihanna,katyperry,ladygaga,jtimberlake,BrunoMars,taylorswift13,TwitterMusic,justinbieber,thalia,selenagomez,jesseyjoy

### Photography

planetepics,LIFE,nasahqphoto,Photoshop,MeetAnimals,HistoricalPics,incredibleviews,nytimesphoto,CuteEmergency,GettyImages,Flickr

### Entertainment

stephenfry,ActuallyNPH,simonpegg,twittermedia,azizansari,jimmyfallon,TheEllenShow,funnyordie,JimCarrey,YouTube,JohnCleese,

### Funny

rickygervais,rustyrockets,TheOnion,SethMacFarlane,alyankovic,

### News

BBCBreaking,TheEconomist,Reuters,CNN,nytimes,Forbes,FoxNews,BBCWorld,nprnews,

### Technology

twitter,TEDTalks,BillGates,lifehacker,google,WIRED,ForbesTech,TechCrunch,gadgetlab,TheNextWeb,wired_business,kaifulee,

### Fashion

CHANEL,hm,VictoriasSecret,voguemagazine,ninagarcia,MarcJacobsIntl,ELLEmagazine,Burberry

## IDs

19923144,155659213,300392950,35936474,42384760,23083404,2557521,19426551,344634424,32765534,26257166,17461978,44409004,79293791,21447363,14230524,26565946,100220864,17919972,373471064,27260086,4101221,23375688,27909036,954590804,18665800,18164420,65525881,953278568,1598644159,126990459,22411875,568825492,40297195,21237045,15439395,90420314,18713254,130649891,6480682,15485441,15846407,15693493,52551600,10228272,10810102,20015311,19562228,14075928,18948541,22461427,5402612,5988062,1652541,759251,807095,91478624,1367531,742143,5392522,783214,15492359,50393960,7144422,20536157,1344951,14885549,816653,11518842,10876852,15208246,50940456,326359913,14399483,16193578,136361303,158128894,109702885,20177423,47459700

## Mongo Stat Command

```shell
mongostat -h 54.187.57.174:10001 -u statAdmin -p statPass
```
