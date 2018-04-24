![MySQL](https://www.mysql.com/common/logos/logo-mysql-170x115.png)

## Supported tags and respective `Dockerfile` links

- `8.0.11`, `8.0`, `8` [(*Dockerfile*)](https://github.com/bezeklik/docker-mysql/blob/master/8.0/Dockerfile)
- `5.7.22`, `5.7`, `5`, `lastest` [(*Dockerfile*)](https://github.com/bezeklik/docker-mysql/blob/master/5.7/Dockerfile)
- `5.6.40`, `5.6` [(*Dockerfile*)](https://github.com/bezeklik/docker-mysql/blob/master/5.6/Dockerfile)
- `5.5.60`, `5.5` [(*Dockerfile*)](https://github.com/bezeklik/docker-mysql/blob/master/5.5/Dockerfile)
- `5.1.73`, `5.1` [(*Dockerfile*)](https://github.com/bezeklik/docker-mysql/blob/master/5.1/Dockerfile)

## Difference from the official image

- image based on CentOS

- install via yum repository

- support for MySQL 5.1

## Quick reference

- **Where to get help:**

- **Where to file issues:**

https://github.com/bezeklik/docker-mysql/issues

- **Maintained by:**

[Bezeklik](https://github.com/bezeklik/)

- **Supported architectures:**

- **Published image artifact details:**

- **Image updates:**

- **Source of this description:**

- **Supported Docker versions:**

## How to use this image

### Usage

```
docker run --interactive --tty --name centos bezeklik/mysql bash
```

## Docker Environment Variables
When you create a MySQL Server container, you can configure the MySQL instance by using the `--env` option (`-e` in short) and specifying one or more of the following environment variables.

#### `MYSQL_ALLOW_EMPTY_PASSWORD`

#### `MYSQL_ROOT_PASSWORD`

#### `MYSQL_RANDOM_ROOT_PASSWORD`

#### `MYSQL_ONETIME_PASSWORD`

#### `MYSQL_DATABASE`

#### `MYSQL_USER`

#### `MYSQL_PASSWORD`
This variable is only supported for MySQL 5.6 and later.

#### `MYSQL_ROOT_HOST`

#### `MYSQL_LOG_CONSOLE`

## License
