# nexus3-nano
Docker build resources for nexus 3 OSS repository using server nano images

To pull the image from docker hub just use:
docker pull tburnett80/nexus3-nano

The default image (latest) is based on nano server 2016 and Nexus version 3.15.2-01

The tags will be (windows architecture)-(nexus oss version) example: sac2016-3.15.2-01


To build this docker file: 
```
docker build --tag nexus-img . 
```

Then to run:
```
docker run -d --name nexus --mount type=bind,source=C:\hostdata,target=C:\data -p 80:8081 nexus-img 
```

and your blobs and other data should be in the host path 'C:\hostdata'
