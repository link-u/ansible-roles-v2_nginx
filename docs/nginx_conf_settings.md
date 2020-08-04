# nginx.conf の設定の逆引きリスト

- [nginx.conf の設定のための変数](#nginxconf-の設定のための変数)
  - [nginx を実行するユーザ名の設定](#nginx_user_name)
  - [ワーカプロセス数の指定](#nginx_worker_processes)
  - [nginx_worker_rlimit_nofile](#nginx_worker_rlimit_nofile)
  - [文字コード](#nginx_charset)
  - [nginx_sendfile](#nginx_sendfile)
  - [nginx_tcp_nopush](#nginx_tcp_nopush)
  - [nginx_tcp_nodelay](#nginx_tcp_nodelay)
  - [nginx_keepalive_timeout](#nginx_keepalive_timeout)
  - [nginx_keepalive_requests](#nginx_keepalive_requests)
  - [nginx_open_file_cache](#nginx_open_file_cache)
  - [nginx_client_max_body_size](#nginx_client_max_body_size)
  - [プロキシキャシュを使用するかどうかのフラグ](#nginx_proxy_cache)
  - [ansible 実行側での証明書等の保存場所](#nginx_ssl_src_base_dir)
  - [nginx.conf の http ディレクティブの最下部に設定を直書きするための変数](#nginx_extra_http_parameters_str)
  - [nginx.conf に設定を直書きするための変数](#nginx_extra_configs)

---

# nginx.conf の設定のための変数 

## nginx_user_name
- nginx を実行するユーザ名

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `"www-data"` | no |

- 書き方例
  ```yaml
  nginx_user_name: "www-data"
  ```
  ```yaml
  nginx_user_name: "nginx"
  ```
<br>

## nginx_worker_processes
- ワーカプロセス数の指定. デフォルト値では min(コア数の半分, 16) を意味している.

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` or `number` | <code>"{{ [([ansible_processor_cores * ansible_processor_count / 2, 1] &#124; max) , 16] &#124; min &#124; round &#124; int }}"</code> | no |

- nginx のワーカプロセス数を4にする例
  ```yaml
  nginx_worker_processes: 4
  ```
<br>

## nginx_worker_rlimit_nofile
- FIXME(@y-hashida): 調べて説明を追記する

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` or `number` | `1000000` | no |

- 書き方例
  ```yaml
  nginx_worker_rlimit_nofile: 1000000
  ```
<br>

## nginx_charset
- 文字コード

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `UTF-8` | no |

- 書き方例
  ```yaml
  nginx_charset: "UTF-8"
  ```
<br>

## nginx_sendfile
- FIXME(@y-hashida): 調べて説明を追記する.

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `"on"` | no |

- ダブルクオーテーション""を必ずつけること.

  指定しなかった場合 boolean になってしまう.

  ```yaml
  nginx_sendfile: "on"   # これは OK
  ```
  ```yaml
  nginx_sendfile: on     # これは NG
  ```
<br>

## nginx_tcp_nopush
- FIXME(@y-hashida): 調べて説明を追記する

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `"on"` | no |

- ダブルクオーテーション""を必ずつけること.

  指定しなかった場合 boolean になってしまう.

  ```yaml
  nginx_tcp_nopush: "on"   # これは OK
  ```
  ```yaml
  nginx_tcp_nopush: on     # これは NG
  ```
<br>

## nginx_tcp_nodelay
- FIXME(@y-hashida): 調べて説明を追記する

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `"on"` | no |
- ダブルクオーテーション""を必ずつけること.

  指定しなかった場合 boolean になってしまう.
  ```yaml
  nginx_tcp_nodelay: "on"   # これは OK
  ```
  ```yaml
  nginx_tcp_nodelay: on     # これは NG
  ```
<br>

## nginx_keepalive_timeout
- FIXME(@y-hashida): 調べて説明を追記する

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` or `number` | `"300"` | no |

- 書き方例
  ```yaml
  nginx_keepalive_timeout: "300"
  ```
<br>

## nginx_keepalive_requests
- FIXME(@y-hashida): 調べて説明を追記する

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` or number | `"10000"` | no |

- 書き方例
  ```yaml
  nginx_keepalive_requests: "10000"
  ```
<br>

## nginx_open_file_cache
- FIXME(@y-hashida): 調べて説明を追記する

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `"max=10000"` | no |

- 書き方例
  ```yaml
  nginx_open_file_cache: "max=10000"
  ```
<br>

## nginx_client_max_body_size
- FIXME(@y-hashida): 調べて説明を追記する

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `"64m"` | no |

- 書き方例
  ```yaml
  nginx_client_max_body_size: "64m"
  ```
<br>

## nginx_proxy_cache
- プロキシキャシュを使用するかどうかのフラグ

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `boolean` | `off` | 必要に応じて |

- 書き方例
  ```yaml
  nginx_proxy_cache: off
  ```
<br>

## nginx_ssl_src_base_dir
- ansible実行側での証明書等の保存場所

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `` | `"{{ inventory_dir }}/files/nginx/ssl"` | no |

- `inventory_dir` インベントリファイルがあるパス.
  ```yaml
  nginx_ssl_src_base_dir: "{{ inventory_dir }}/files/nginx/ssl"
  ```

- デフォルトの設定の場合 SSL 証明書の配置場所は以下のようになる.
  ```
  ansible-project/
  ├── hosts  # インベントリファイル
  ├── files/
  │   └── nginx/
  │       └── ssl/
  │           └── [sample]/   <=== このディレクトリ内に配置。[sample]は変数 nginx_vhost_settings[0].confi_file_name
  │               ├── coressl.crt
  │               ├── dhparam2048.pem
  │               ├── server.key
  │               └── server.pem
  ├── roles/
  │   ├── nginx/
  ```
<br>

## nginx_extra_http_parameters_str
- http ディレクティブを String で直接記述

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `""` | 必要に応じて |

- 先頭にインデントを 4-space 入れる!!
- 書き方例
  ```yaml
  nginx_extra_http_parameters_str: |
    log_format ltsv 'time:$time_iso8601\t'
                    'status:$status\t'
                    'remote_addr:$remote_addr\t'
                    'request_method:$request_method\t'
                    'request_uri:$request_uri\t'
                    'host:$host\t'
                    'request_time:$request_time\t'
                    'upstream_response_time:$upstream_response_time\t'
                    'bytes_sent:$bytes_sent\t'
                    'referer:$http_referer\t'
                    'useragent:$http_user_agent\t'
                    'app_info:$upstream_http_x_app_info';
    fastcgi_buffers 8 128k;
    fastcgi_buffer_size 256k;
    map $http_origin $cors {
        default "NG";
        "https://hoge.example.com" "OK";
        "https://foo.example.com" "OK";
        "https://bar.example.com" "OK";
    }
  ```
<br>

## nginx_extra_configs
- nginx.conf に設定を直書きするための変数

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `""` | 必要に応じて |

- rtmp ディレクティブを書き足す例
  ```yaml
  _nginx_hls_path: "/var/www/hls"
  _nginx_rtmp_port: "1935"
  nginx_extra_configs: ｜
    rtmp {
        server {
            listen {{ _nginx_rtmp_port }};
            application hls {
                live on;
                hls  on;
                hls_path {{ _nginx_hls_path }};
                hls_fragment 100ms;
                hls_type live;
                hls_playlist_length 5s;
            }
        }
    }
  ```
