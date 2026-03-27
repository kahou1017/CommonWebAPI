# Common API 文件索引

本目錄存放 Common API 架構與技術設計文件，所有文件均使用 `UTF-8` 編碼，中文內容以台灣繁體中文與台灣常用用字為主。

## 文件結構

```text
docs/
  README.md
  architecture/
    overview.md
    project-structure.md
  api/
    response-spec.md
  decisions/
    open-issues.md
  logging/
    logging-and-trace-spec.md

sql/
  logging/
    create-api-request-log.sql
    create-api-exception-log.sql
```

## 文件說明

### 架構總覽

- [architecture/overview.md](./architecture/overview.md)
  Common API 的目標、設計原則、技術選型、整體架構與第一版實作範圍。

### 專案結構

- [architecture/project-structure.md](./architecture/project-structure.md)
  Solution、專案、資料夾結構與命名規範。

### API 規格

- [api/response-spec.md](./api/response-spec.md)
  API 成功、失敗、分頁、驗證錯誤的回應格式與 C# DTO 樣板。

### Logging / Trace

- [logging/logging-and-trace-spec.md](./logging/logging-and-trace-spec.md)
  TraceId、ApiRequestLog、ApiExceptionLog、Body Logging Policy 與 Background Log Queue 規格。
- [logging/logging-entity-mapping.md](./logging/logging-entity-mapping.md)
  Logging 相關資料表與 C# Entity / DTO 的對應表。

### 待決議事項

- [decisions/open-issues.md](./decisions/open-issues.md)
  記錄已討論但尚未正式定案的主題，方便後續持續追蹤與延續討論。

### SQL 檔案

- [../sql/logging/create-api-request-log.sql](../sql/logging/create-api-request-log.sql)
  `ApiRequestLog` 的 SQL Server 建表與索引腳本。
- [../sql/logging/create-api-exception-log.sql](../sql/logging/create-api-exception-log.sql)
  `ApiExceptionLog` 的 SQL Server 建表與索引腳本。

## 後續擴充建議

未來可依主題持續擴充更多文件，例如：

- `data/dapper-strategy.md`
- `integration/external-api-integration-spec.md`
- `security/token-and-caller-strategy.md`
- `logging/background-log-queue-spec.md`
- `logging/external-api-call-log-spec.md`
