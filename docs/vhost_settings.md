# Virtual host の設定の逆引きリスト

- [Virtual host の設定のための変数](#Virtual-host-の設定のための変数)
  - [未定義の conf ファイルを削除するフラグ](#nginx_remove_undefined_vhost_conf)
  - [conf ファイルを変更したときに conf ファイルを残す](#nginx_virtual_host_config_backup)
  - [nginx のデフォルト IP アドレスホワイトリスト](#nginx_default_ip_white_list)
  - [nginx の virtual host を細かく設定する](#nginx_vhosts)
  - [nginx_vhost_base_settings](#nginx_vhost_base_settings)
  - [nginx_vhost_base_settings 内の各変数](#nginx_vhost_base_settings-内の各変数)
    - [conf ファイル名](#conf_file_name)
    - [listen_list](#listen_list)
    - [ドキュメントルート](#root)
    - [サーバ名](#server_name)
    - [アクセスログ](#access_log)
    - [エラーログ](#error_log)
    - [log_not_found](#log_not_found)
    - [エラーページ](#error_pages)
    - [SSL サーバ証明書](#ssl)
    - [unicorn_sock](#unicorn_sock)
    - [IP 制限](#ip_restriction)
    - [Basic 認証](#auth_basic_user)
    - [プロキシの設定](#proxies)
    - [location の設定](#locations)
    - [Virtual host の設定を直接記述するための変数](#extra_parameters_str)

---

# Virtual host の設定のための変数

## nginx_remove_undefined_vhost_conf

- 未定義の conf ファイルを削除するフラグ

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `boolean` | `off` | 必要に応じて |

- ファイルの削除をする操作なので, 本番環境で使う場合は慎重に!!!
- 書き方例
  ```yaml
  nginx_remove_undefined_vhost_conf: on
  ```
<br>

## nginx_virtual_host_config_backup
- conf ファイルを変更したときに conf ファイルを残すフラグ

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `boolean` | `off` | 必要に応じて |

- 書き方例
  ```yaml
  nginx_virtual_host_config_backup: on
  ```
<br>

## nginx_default_ip_white_list
- nginx のデフォルト IP アドレスホワイトリストを設定する変数<br>
  後述する [ip_restriction](#ip_restriction) と関係してくる.

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `list` | `["127.0.0.1"]` | 必要に応じて |

- 設定例
  ```yaml
  nginx_default_ip_white_list:
    - "127.0.0.1"        # ループバックアドレスを指定
    - "192.0.2.0/24"     # ネットワークアドレス指定の例
    - "198.51.100.1"     # IP アドレスを指定
  ```
<br>

## nginx_vhosts
- Virtual host を設定する変数

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `list` | `[]` | 必要に応じて |

- 書き方例
  ```yaml
  _vhost_01:
    conf_file_name: web.conf
    server_name: web.example.com
    index: "index.html index.php"

  _vhost_02:
    conf_file_name: api.conf
    server_name: api.example.com
    index: "index.html index.php"

  _vhost_03:
    conf_file_name: cms.conf
    server_name: cms.example.com
    index: "index.html index.php"

  nginx_vhosts:
    - "{{ _vhost_01 }}"
    - "{{ _vhost_02 }}"
    - "{{ _vhost_03 }}"
  ```

  ここで指定した `_vhost_01`, `_vhost_02`, `_vhost_03` は `nginx_vhost_base_settings`
  という変数 ([後述する](#nginx_vhost_base_settings)) にマージされて取り扱われる.
  すなわち `nginx_vhost_base_settings` がデフォルトの値となる.

- dict 型の変数のマージの実装方法について

  `item` は `nginx_vhosts` 内の各要素

  ```yaml
  {% set vhost = (nginx_vhost_base_settings | combine(item) )%}
  ```
<br>

## nginx_vhost_base_settings
- vars に定義される変数

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `dict` | 書ききれないので↓に示す | この変数自体は変更不可能 |

- nginx_vhost_base_settings の基本構造

  `nginx_vhost_base_settings` の基本構造を以下に示す.

  ここで, すでに設定されている値はデフォルト値である.

  ```yaml
  nginx_vhost_base_settings:
    conf_file_name: localhost.conf
    listen_list: ['80']
    root: off
    server_name: localhost
    index: "index.php index.html"
    access_log: off
    error_log: off
    log_not_found: off
    error_pages: []
    ssl: off
    unicorn_sock: off
    ip_restriction: off
    auth_basic_user: off
    proxies: []
    locations:
      - location: "/"
        value: |
          root   /var/www/html;
          index  index.html;
    extra_parameters_str: ""
  ```
<br>

## nginx_vhost_base_settings 内の各変数
### conf_file_name
- `/etc/nginx/conf.d/` に保存される `.conf` ファイルの名前.

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `"localhost.conf"` | ほとんどの場合で必要 |

- 各 virtual host ごとに別ファイルになるように指定する.
- 設定例 
  ```yaml
  conf_file_name: localhost.conf
  ```
<br>

### listen_list
- バーチャルサーバが使用するアドレス, ポートを指定する変数.

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `list` | `["80"]` | 必要に応じて変更 |

- 設定例 
  ```yaml
  listen_list:
    - "80"
    - "443 ssl"
    - "localhost:8080"
  ```
<br>

### root
- ドキュメントルートを定義する変数. `boolean` or `string` で指定.

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `boolean` or `string` | `off` | 必要に応じて変更 |

- `boolean` の場合の設定例
  ```yaml
  root: on   # ドキュメントルートを "/" にする.
  ```
  ```yaml
  root: off  # ドキュメントルートを設定しない.
  ```
- `string` の場合の設定例
  ```yaml
  root: "/var/www/api/current/public"  # 指定したパスをドキュメントルートにする.
  ```
<br>

### server_name
- バーチャルホストのサーバ名

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `boolean` | `localhost` | ほとんどの場合で必要 |

- 設定例 
  ```yaml
  server_name: example.com
  ```
<br>

### access_log
- アクセスログについて設定する変数. `boolean` or `string` で指定.

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `boolean` or `string` | `off` | 必要に応じて変更 |

- `boolean` の場合の設定例
  ```yaml
  access_log: on   # /var/log/nginx/{{ vhost.server_name }}-access.log  に保存する
  ```
  ```yaml
  access_log: off  # アクセスログを設定しない.
  ```
- `string` の場合の設定例
  ```yaml
  access_log: "/var/log/nginx/api-access.log"       # 指定したパスにログを保存する
  ```
  ```yaml
  access_log: "/var/log/nginx/api-access.log ltsv"  # このように追加パラメータを与えることもできる.
  ```
<br>

### error_log
- エラーログについて設定する変数. boolean or string で指定. 

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `boolean` or `string` | `off` | 必要に応じて変更 |

- `boolean` の場合の設定例
  ```yaml
  error_log: on   # /var/log/nginx/{{ vhost.server_name }}-error.log  に保存する
  ```
  ```yaml
  error_log: off  # アクセスログを設定しない.
  ```
- `string` の場合の設定例
  ```yaml
  error_log: "/var/log/nginx/api-error.log"  # 指定したパスにログを保存する
  ```
<br>

### log_not_found
- ファイルが存在しない場合のエラー出力を有効 or 無効にするための変数.

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `boolean` | `off` | no |

- 存在しないファイルリクエストがあった場合のエラー出力は冗長なのでデフォルトで `off` にしてある. 
- 設定例 
  ```yaml
  log_not_found: on  # この場合, 存在しないファイルリクエストがあった場合のエラー出力が有効になる.
  ```
<br>

### error_pages
- エラー時に表示するページをリストで指定する.

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `list` | `[]` | yes |

- 設定例 
  ```yaml
  error_pages: 
    - "404    /404.html"
    - "500 502 503 504   /50x.html"
  ```
<br>

### ssl
- SSL サーバ証明書について設定する変数. 

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `boolean` or `nginx_vhost_base_settings_for_ssl` 形式 | `off` | yes |

- `boolean` or `nginx_vhost_base_settings_for_ssl` 形式で指定. <!-- FIXME(@y-hashida): nginx_vhost_base_settings_for_ssl についてページ内リンクを貼る -->
- boolean の場合の設定例
  ```yaml
  ssl: on    # nginx_vhost_base_settings_for_ssl のデフォルト値が設定される
  ```
  ```yaml
  ssl: off   # SSL サーバ証明書に関する設定をしない
  ```
- `nginx_vhost_base_settings_for_ssl` 形式の場合の設定例
  ```yaml
  ssl:
    src_dir_name: "_example.com"
    dest_dir: "/etc/nginx/ssl/_example.com/"
    certificate_file: "coressl.crt"
    certificate_key_file: "server.key"
    dhparam_file: "dhparam2048.pem"
  ```
<br>

### unicorn_sock
- set socket file path when used. don't set 'on' # FIXME(@y-hashida) わからないので調べておく

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `boolean` | `off` | no |

- 設定例 
  ```yaml
  unicorn_sock: off
  ```
<br>

### ip_restriction
- nginx のバーチャルホストにアクセスできる IP アドレスのホワイトリストを設定するための変数.

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `boolean` | `off` | 必要に応じて |

- 設定例: ホワイトリストが必要ない場合
  ```yaml
  ip_restriction: off
  ```

- 設定例: バーチャルホストにアクセスできる IP アドレスのホワイトリストを明示的に指定.
  ```yaml
  ip_restriction:
    white_list:
      - "192.0.2.0/24"     # ネットワークアドレス指定の例
      - "198.51.100.1"     # IP アドレスを指定
  ```

- 設定例: 単純に `on` にする場合
  ```yaml
  ip_restriction: on
  ```

  これは以下の設定と等価.

  ```yaml
  ip_restriction:
    white_list: "{{ nginx_default_ip_white_list }}"
  ```
<br>

### auth_basic_user
- Basic 認証について設定する変数.

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `boolean` or `dict` | `off` | no |

- `boolean` の否定値か, 以下に示す `dict` で定義する. 
- `boolean` の場合の設定例
  ```yaml
  auth_basic_user: on     # 不正な値
  ```
  ```yaml
  auth_basic_user: off    # Basic 認証を使用しない設定
  ```
- `dict` の場合の設定例
  ```yaml
  auth_basic_user:
    htpasswd_path: /path/to/htpasswd_file   # デフォルト値は "/etc/nginx/.htpasswd" 
    accounts:
      - name: sample-user1
        password: pass1
      - name: sample-user2
        password: pass2
  ```
<br>

### proxies
- define item.proxy as dictionary when non-default settings are used
- FIXME(@y-hashida) この変数の使い方よりも, nginx のプロキシ設定を調べる必要あり.
- FIXME(@y-hashida) プロキシ関係は色んな所に設定が分散されている. 改めて見直して, 簡単にしたい.

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `list` | `[]` | no |

- 設定例 
  ```yaml
  省略
  ```
<br>

### locations
- location を設定する変数.

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `dict` の `list` | 以下に示す | yes |

- `{location: "location", value:"value"}` の `dict` を `list` として持つ.
- デフォルト値
  ```yaml
  locations:
    - location: "/"
      value: |
        root   /var/www/html;
        index  index.html;
  ```
- 設定例 
  ```yaml
  locations:
    - location: "/"
      value: |
        if ($request_method = 'OPTIONS') {
          add_header Access-Control-Allow-Origin 'https://localhost';
          add_header Access-Control-Allow-Methods 'GET, POST, PUT, DELETE';
          add_header Access-Control-Allow-Headers 'Origin, Authorization, Accept, Content-Type';
          add_header Access-Control-Allow-Credentials true;
          add_header Access-Control-Max-Age 3600;
          add_header Content-Type 'text/plain charset=UTF-8';
          add_header Content-Length 0;
          return 204;
        }
        try_files $uri $uri/ @rewrite;

    - location: "~ \\.php$"
      value: |
        add_header Access-Control-Allow-Origin 'https://localhost';
        add_header Access-Control-Allow-Methods 'GET, POST, PUT, DELETE';
        add_header Access-Control-Allow-Headers 'Origin, Authorization, Accept, Content-Type';
        add_header Access-Control-Allow-Credentials true;
        add_header Access-Control-Max-Age 3600;
        include fastcgi_params;
        fastcgi_index index.php;
        fastcgi_pass unix:/run/php/php7.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME  $realpath_root$fastcgi_script_name;
        fastcgi_hide_header "X-APP-INFO";
  ```
<br>

### extra_parameters_str
- Virtual host の設定を直接記述するための変数.

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `""` | no |

- 設定例 
  ```yaml
  extra_parameters_str: |
    try_files $uri $uri/ /index.html;  
  ```
