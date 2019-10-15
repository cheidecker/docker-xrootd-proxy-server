# docker-xrootd-proxy-server

## Building the docker image

All necessary files are contained in the `BUILD` directory. This contains a `Dockerfile`, starting scripts for XRootD services and VOMS proxy creation.

You can build the docker image using the building script and will get an image called `test-image:latest`.

```
./BUILD/build.sh
```

## Converting the image

The procedure of converting the docker image to a singularity image depends on the version of singularity you will use. 

The conversion script automatically chooses the method according to the installed singularity version.

```
./CONVERT/convert.sh
```
You will get a suitable singularity image called `xrootd-caching-proxy.<sif/simg>`.

### Singularity version >= 3.0

Here you can directly convert the image by using the build command.

### Singularity version < 3.0

Since the `build` command of singularity creates a non-functional image, you need to upload the image to a dockerhub repo before building a singularity image while downloading it.

## Running the container

Starting scripts for docker and singularity can be found in the `RUN` directory. 
These automatically mount the `CACHE` and `HOME_DIR` into`/opt/cache` and `/opt/xrootd`. 
Furthermore, they start an `xrootd` and an `cmsd` service for every XRootD config file (ending on `*.cf`) placed in `HOME_DIR/configs/`.
Additionally, an GSI VOMS proxy certificate is created using the `ùserkey.pem` and `usercert.pem` (or `usercred.p12`) placed in `HOME_DIR/.globus/` and renews is every 24 hours.

### For docker

```
./RUN/docker-run.sh
```

### For singularity

```
./RUN/singularity-run.sh
```