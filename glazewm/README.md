# Manage Config GlazeWM

Config management of GlazeWM via personal git repository

## Install GlazeWM

```
scoop bucket add extras
scoop install extras/glazewm
```

need to install `zebar` too.

```
scoop install zebar
```

## Check Config File Location

When GlazeWM installed and _run for the first time_, `.glzr\glazewm` folder is created in the following location.

`C:\Users\user_name\.glzr\`

you should locate config file (`config.yaml`) for GlazeWM here.
For this, you're going to use personal git folder. `https://github.com/jkkow/glazewm`

## Git clone

First remove the `\glazewm` folder in comand line, and then clone config files from this git repo.

```
git clone git@github.com:jkkow/glazewm.git
```
