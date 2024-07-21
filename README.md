# add-filter-for-ruby

Clone to the directory on the same level as the project you wish to modify.

## command
```
$ docker build -t add-app .
$ docker run -v ./../:/mnt --env DIR=[your_app_dir_name] --env CMD=[filtering_command] --env FIL=[setting_filter] --rm add-app
$ docker image rm add-app
```
