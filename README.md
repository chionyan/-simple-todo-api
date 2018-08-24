# simple-todo-api

## 目的

以下の仕様で [API 専用 アプリケーション](https://railsguides.jp/api_app.html)の実装を行う。

## API 仕様

ref. https://app.swaggerhub.com/apis/sukechannnn/TODO-API/1.0.0/

## オブジェクトのデータ構造

### 1. Todo

| 項目名       | 型       | 備考                                                |
| ------------ | -------- | --------------------------------------------------- |
| `id`         | `string` | `Todo#id` (UUID) を文字列にしたもの                 |
| `title`      | `string` | `Todo#title` そのまま                               |
| `text`       | `string` | `Todo#text` そのまま                                |
| `created_at` | `string` | `Todo#created_at` を UTC の ISO 8601 形式にしたもの |

## 例外処理の設計

アクション|異常パターン|HTTP ステータス|ボディ
:----:|:----:|:---:|:---
GET /todos/:id<br>PATCH /todos/:id<br>DELETE /todos/:id | レコードが存在しない<br>(ActiveRecord::RecordNotFound) | 404 | errors/title: "見つかりませんでした。"<br>errors/status: 404
POST /todos<br>PATCH(PUT) /todos/:id | 入力の不備<br>(ActiveRecord::RecordInvalid) | 422 | errors/title: "バリデーションに失敗しました。。"<br>errors/source/pointer: "/data/attributes/{attribute name}"<br>errors/status: 422


## 実装全体におけるスコープ外

- [クエリ文字列](https://railsguides.jp/routing.html#%E3%82%AF%E3%82%A8%E3%83%AA%E6%96%87%E5%AD%97%E5%88%97)による検索機能の実装
- サーバエラー応答(5xx)のエラーハンドリング
- Request Parameter の Content-Type は `json/application` 以外でも許可することとする
