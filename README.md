# CommonWebAPI

本專案用於規劃與整理一套標準化的 Common API 架構設計，目標是建立可快速導入、易於重構、便於擴充，且具備良好追蹤能力的 `.NET / ASP.NET Core Web API` 基礎樣板。

目前此 repository 以架構設計文件與 SQL 規格為主，包含：

- Common API 整體架構與設計原則
- 專案分層與命名規範
- API Response / Error Response 規格
- Logging / Trace 設計
- `ApiRequestLog` / `ApiExceptionLog` 的 SQL Server 建表腳本
- 已討論但尚未定案事項的追蹤文件

## 文件入口

詳細內容請參考 [docs/README.md](./docs/README.md)。

主要文件如下：

- [docs/architecture/overview.md](./docs/architecture/overview.md)
- [docs/architecture/project-structure.md](./docs/architecture/project-structure.md)
- [docs/api/response-spec.md](./docs/api/response-spec.md)
- [docs/logging/logging-and-trace-spec.md](./docs/logging/logging-and-trace-spec.md)
- [docs/logging/logging-entity-mapping.md](./docs/logging/logging-entity-mapping.md)
- [docs/decisions/open-issues.md](./docs/decisions/open-issues.md)

## SQL 腳本

SQL Server 建表腳本位於：

- [sql/logging/create-api-request-log.sql](./sql/logging/create-api-request-log.sql)
- [sql/logging/create-api-exception-log.sql](./sql/logging/create-api-exception-log.sql)

## 後續方向

後續可持續補充：

- `.NET` 專案骨架
- Middleware 實作骨架
- Dapper Repository / Query Service 範例
- Token / Caller Identity 規格
- External API Integration 規格

## 文件規範

- 所有文件與設計物件統一採用 `UTF-8` 編碼
- 中文內容以台灣繁體中文與台灣常用用字為主
