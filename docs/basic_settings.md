# nginx role の基本設定の逆引きリスト

- [nginx role の基本設定のための変数](#nginx-role-の基本設定のための変数)
  - [インストールはせずに, 設定のみしたい](#nginx_install_flag)
  - [nginx のバージョンの指定](#nginx_version)
  - [nginx のログを保存するディレクトリを指定する](#nginx_log_directory)
  - [nginx のアクセスログの保存ディレクトリ](#nginx_access_log)
  - [nginx のエラーログの保存ディレクトリ](#nginx_error_log)
  - [nginx のエラーログレベルの指定](#nginx_error_log_level)
  - [ディレクトリの作成](#nginx_extra_directories)

---  

# nginx role の基本設定のための変数

## nginx_install_flag
- インストールフラグ

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `boolean` | `True` | no |

- `False` の時, [インストールタスク](../tasks/install.yml)は実行しない.
  ```yaml
  nginx_install_flag: False
  ```
<br>

## nginx_version
- nginx のバージョン

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `"latest"` | no |

- nginx のインストールバージョンを指定する.

- デフォルト値ではその時の最新版がインストールされる.
  ```yaml
  nginx_version: "1.17.7-1"   # 明示的に 1.17.7-1 版をインストールする設定
  ```
<br>

## nginx_log_directory
- nginx のログを保存するディレクトリ

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `"/var/log/nginx"` | no |

- 書き方例
  ```yaml
  nginx_log_directory: "/var/log/nginx"
  ```
<br>

## nginx_access_log
- nginx のアクセスログの保存ディレクトリ

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `"{{ nginx_log_directory }}/access.log"` | no |

- 書き方例
  ```yaml
  nginx_access_log: "{{ nginx_log_directory }}/access.log"
  ```
<br>

## nginx_error_log
- nginx のエラーログの保存ディレクトリ

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `"{{ nginx_log_directory }}/error.log"` | no |

- 書き方例
  ```yaml
  nginx_error_log: "{{ nginx_log_directory }}/error.log"
  ```
<br>

## nginx_error_log_level
- nginx のエラーログレベルの指定

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `string` | `"warn"` | no |

- 書き方例
  ```yaml
  nginx_error_log_level: warn
  ```
<br>

## nginx_extra_directories
- 新規作成するディレクトリ

  | 種類 | デフォルト値 | 変更必須 |
  | :--- | :--------- | :--- |
  | `list` | `[]` | no |

- 書き方例
  ```yaml
  nginx_extra_directories: ["/var/www/html", "/var/www/hls"]
  ```
