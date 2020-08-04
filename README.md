# Nginx

## 概要
nginx role について使い方を説明している.

## 動作確認バージョン
- Ubuntu 18.04 (bionic)
- ansible >= 2.8
- Jinja2 2.10.3

## 使い方 (ansible)

### Role variables

```yaml
### インストール設定 ###############################################################################
##　基本設定
## インストールフラグ
#  * False にすると install.yml をスキップできる.
#  * サーバ班が設定だけ流し込みたいときに使用する.
#  * install.yml の中には apt 関係のモジュールが書き込まれている.
nginx_install_flag: True

## 基本設定
nginx_log_directory: /var/log/nginx
nginx_access_log: "{{ nginx_log_directory }}/access.log"
nginx_error_log: "{{ nginx_log_directory }}/error.log"
nginx_extra_directories: []
nginx_error_log_level: warn

### conf ファイル 設定 #############################################################################
nginx_user_name: "www-data"
nginx_worker_processes: >-                # min(コア数の半分, 16)
  {{ [([ansible_processor_cores * ansible_processor_count / 2, 1] | max) , 16] | min | round | int }}
nginx_worker_rlimit_nofile: 1000000
nginx_charset: "UTF-8"
nginx_sendfile: "on"                      # String
nginx_tcp_nopush: "on"                    # String
nginx_tcp_nodelay: "on"                   # String
nginx_keepalive_timeout: "300"
nginx_keepalive_requests: "10000"
nginx_open_file_cache: "max=10000"
nginx_client_max_body_size: "64m"
nginx_proxy_cache: off

## ansible実行側での SSL 証明書等の保存場所
nginx_ssl_src_base_dir: "{{ inventory_dir }}/files/nginx/ssl"
## デフォルトでは以下のディレクトリに保存されている SSL 証明書を参照する.
# ansible-project/
# ├── hosts  # インベントリファイル
# ├── files/
# │   └── nginx/
# │       └── ssl/
# │           └── [sample]/   <=== このディレクトリ内に配置。[sample]は変数 nginx_vhost_settings[0].confi_file_name
# │               ├── coressl.crt
# │               ├── dhparam2048.pem
# │               ├── server.key
# │               └── server.pem
# ├── roles/
# │   ├── nginx/

## nginx.conf 下部に設定を直書きするための変数
nginx_extra_configs: ""
## 設定例
# 1. rtmp ディレクティブを設定
# _nginx_hls_path: "/var/www/hls"
# _nginx_rtmp_port: "1935"
# nginx_extra_configs: |
#   rtmp {
#       server {
#           listen {{ _nginx_rtmp_port }};
#           application hls {
#               live on;
#               hls  on;
#               hls_path {{ _nginx_hls_path }};
#               hls_fragment 100ms;
#               hls_type live;
#               hls_playlist_length 5s;
#           }
#       }
#   }

## http ディレクティブ内での設定を直書きするための変数
# ※インデントは 4-space
nginx_extra_http_parameters_str: ""
## 設定例
# nginx_extra_http_parameters_str: |
#   log_format ltsv 'time:$time_iso8601\t'
#                   'status:$status\t'
#                   'remote_addr:$remote_addr\t'
#                   'request_method:$request_method\t'
#                   'request_uri:$request_uri\t'
#                   'host:$host\t'
#                   'request_time:$request_time\t'
#                   'bytes_sent:$bytes_sent\t'
#                   'referer:$http_referer\t'
#                   'useragent:$http_user_agent\t'
#                   'app_info:$upstream_http_x_app_info';
#   fastcgi_buffers 8 128k;
#   fastcgi_buffer_size 256k;
#   map $http_origin $cors {
#       default "NG";
#       "https://hogehoge.com" "OK";
#       "https://foofoo.com" "OK";
#       "https://barbar.com" "OK";
#   }

## Virtual host の conf ファイルに対する設定
nginx_remove_undefined_vhost_conf: False  # 未定義の conf ファイルを削除するフラグ
nginx_virtual_host_config_backup: off     # on/off : conf ファイルを変更したときに conf ファイルを残すフラグ
nginx_default_ip_white_list:              # nginx にアクセスできるデフォルト IP アドレスホワイトリスト
  - "127.0.0.1"

## Virtual host を設定する変数
nginx_vhosts: []                          # 初期値は空の配列
## 設定例
# 1. まずはとてもシンプルな設定例
# _vhost_web:
#   conf_file_name: web.conf
#   server_name: web.hogehoge.com
#   index: "index.html index.php"
# 
# _vhost_api:
#   conf_file_name: api.conf
#   server_name: api.hogehoge.com
#   index: "index.html index.php"
# 
# _vhost_cms:
#   conf_file_name: cms.conf
#   server_name: cms.hogehoge.com
#   index: "index.html index.php"
# 
# nginx_vhosts:
#   - "{{ _vhost_web }}"
#   - "{{ _vhost_api }}"
#   - "{{ _vhost_cms }}"
#
# 2. 1.の説明
#   辞書変数 _vhost_{web,api,cms} は, 
#   次の辞書変数 nginx_vhost_base_settings の中から一部分だけ変更したものである.
# nginx_vhost_base_settings:
#   conf_file_name: "localhost.conf"
#   listen_list: ["80"]
#   root: off
#   server_name: "localhost"
#   index: "index.php index.html"
#   access_log: off
#   error_log: off
#   log_not_found: off
#   error_pages: []
#   ssl: off
#   unicorn_sock: off
#   ip_restriction: off
#   auth_basic_user: off
#   proxies: []
#   locations:
#     - location: "/"
#       value: |
#         root   /var/www/html;
#         index  index.html;
#   extra_parameters_str: ""
```

### Example playbook
```yaml
- hosts:
    - servers
  become: True
  roles:
    - { role: nginx,   tags: ["nginx"] }
```

### nginx の設定について
#### 設定について
基本的に[設定マニュアル](docs/conf_manual.md)を参照

#### SSL サーバ証明書の配置について
[設定マニュアル](docs/conf_manual.md)にも書いてはいるが, これについてはここにも書いておいたほうが良さそうなので載せておく.

インベントリファイルから参照できる場所に置き, ディレクトリパスを変数で指定すること.
以下がデフォルトのSSL証明書関連ファイル置き場である.
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

## その他の設定例 FIXME(@y-hashida): いずれ別ファイルに書き直したい

### RTMP の nginx_extra_configs 設定例

`group_vars` に以下のような設定を追加する.

```yaml
_nginx_hls_path: "/var/www/hls"
_nginx_rtmp_port: "1935"

nginx_extra_directorys:
  - "{{ _nginx_hls_path }}"
nginx_ports:
  - "80"
  - "443"
  - "{{ _nginx_rtmp_port }}"   ## RTMP のポート番号を追記
nginx_extra_configs: |
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

## secure_link modulesの設定例

### nginxの設定

```yaml
# この文字列を知らないとリンクが生成できないようになっている。
# 下のURL生成コードと合わせてください。
# 変えようね。
_nginx_secure_secretkey: "hogehogezoizoi"

# nginxのlocation directiveの設定例：
    - location: "~ /secure/(\\d+)/(?<path>.*)$"
      value: |
        set $secretkey "{{ _nginx_secure_secretkey }}";
        secure_link $arg_hash,$arg_expires;
        secure_link_md5 $secretkey$uri$arg_expires;
        if ($secure_link = "") {
          return 403;
        }
        if ($secure_link = "0") {
          return 403;
        }
        alias /var/www/static/$path;
        expires 1d;
```

### URLの生成（PHPの例）

```php
<?php
$url = '/secure/114514/webp/title_main/1.webp'; // (いわゆるURLエンコードすること)
$expires=time()+3600*24;

$secretkey="hogehogezoizoi";
$regulerURL=str_replace(array('%2f','%2F'),'/',$url);
$hashBase=$secretkey.$regulerURL.$expires;
$hash=strtr(rtrim(base64_encode(hash('md5',$hashBase,1)),'='), '+/',
'-_');
echo $url.'?hash='.$hash.'&expires='.$expires."\n";
```

## 後方互換性について

### 削除された変数の一覧

以下の変数は `group_vars` から削除して頂いて大丈夫です.

* `nginx_ports` と `no_firewall`
  * ポート開放はすべて ufw role で実行する方針に切り替えたため削除しました.
