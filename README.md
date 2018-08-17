# simple-todo-api

## 目的

以下の仕様で [API 専用 アプリケーション](https://railsguides.jp/api_app.html)の実装を行う。

## API 仕様

ref. https://app.swaggerhub.com/apis/kielze/TODO-API/1.0.0/

## オブジェクトのデータ構造

### 1. Todo

| 項目名       | 型       | 備考                                                |
| ------------ | -------- | --------------------------------------------------- |
| `id`         | `string` | `Todo#id` (UUID) を文字列にしたもの                 |
| `title`      | `string` | `Todo#title` そのまま                               |
| `text`       | `string` | `Todo#text` そのまま                                |
| `created_at` | `string` | `Todo#created_at` を UTC の ISO 8601 形式にしたもの |

## 実装全体におけるスコープ外

- [クエリ文字列](https://railsguides.jp/routing.html#%E3%82%AF%E3%82%A8%E3%83%AA%E6%96%87%E5%AD%97%E5%88%97)による検索機能の実装
- サーバエラー応答(5xx)のエラーハンドリング
- Request Parameter の Content-Type は `json/application` 以外でも許可することとする
