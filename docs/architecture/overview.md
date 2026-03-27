# Common API Architecture Overview v1

## 1. 文件目的

本文件定義一套標準化、可快速導入、可重構、可擴充的 Common API 架構，作為後續 `.NET Web API` 專案的基礎樣板。

## 1.1 文件與設計物件編碼規範

- 本專案之設計文件、設定檔、程式碼檔案與相關輸出物，統一採用 `UTF-8` 編碼。
- 中文內容以台灣繁體中文為主，並優先使用台灣常用術語與用字。
- 後續新增或修訂文件時，應延續本規範，避免出現簡體中文、非一致術語或編碼不一致問題。

## 1.2 核心目標

1. 提供可迅速導入的 API 架構，方便移植與複用。
2. 支援可重構、可彈性擴充的模組設計，降低模組間依賴。
3. 採用 `.NET / ASP.NET Core Web API` 開發 RESTful API。
4. 保持資料來源通用性，不綁定特定 DB 類型。
5. 具備 Request / Response 可追蹤性，方便日後查詢與除錯。
6. 可同時整合資料庫查詢與外部 API 服務。

---

## 2. 設計原則

### 2.1 分層清楚

- API 層只負責接收請求、輸出回應、Middleware、Swagger。
- Application 層負責流程編排與業務協調。
- Domain 層負責核心概念、錯誤碼、例外、共通規則。
- Infrastructure 層負責 DB、Dapper、外部 API、Logging、Audit 等技術實作。

### 2.2 低耦合與可替換

- Application 不直接依賴 Dapper、SQL、HttpClient。
- 所有 DB / 外部 API 實作皆透過介面抽象。
- 未來可替換 DB provider、外部 API provider，而不影響上層。

### 2.3 統一輸出格式

- API Response / Error Response 必須統一。
- 透過標準 envelope 提供固定欄位與可追蹤資訊。

### 2.4 可追蹤性

- 每次請求需帶有 `TraceId`。
- Request / Response / Exception 需具備可回查機制。

### 2.5 先求可落地，再保留擴充點

- 第一版優先建立完整骨架與追蹤能力。
- 對遮罩、特殊排除、外部 API 治理保留擴充點。

---

## 3. 技術選型

### 3.1 API Framework

- `.NET`
- `ASP.NET Core Web API`

### 3.2 資料存取

目前建議以 `Dapper` 為主，原因如下：

- 現況已有 SQL 可直接使用。
- 查詢來源可能來自產品 DB 或混合自建資料表。
- 複雜 SQL 與既有查詢整合比 EF Core 更靈活。
- 適合整合型、查詢型 API 場景。

> 補充：未來若有大量自建 CRUD 資料表，可再評估局部引入 EF Core。

### 3.3 外部 API 整合

- 採用 `HttpClientFactory`
- 外部 API 視為 Infrastructure Adapter
- Application 層不直接依賴 HttpClient 細節

### 3.4 Logging

- 本地 Log：`ILogger` + 後續可接 Serilog / File / Console / Log Platform
- DB Log：以 Dapper 寫入 Log Table
- 背景寫入：`Channel + BackgroundService`

---

## 4. 整體架構

```text
Client
  ↓
CommonApi.Api
  ↓
CommonApi.Application
  ↓
CommonApi.Domain
  ↓
CommonApi.Infrastructure
    ├─ Persistence
    ├─ Integrations
    ├─ Logging
    └─ Audit
  ↓
Database / External APIs
```

---

## 5. 資料來源整合模式

### 5.1 原則

- Controller 不直接呼叫 Dapper。
- Controller 不直接呼叫外部 API。
- Application Service 負責協調資料來源。
- Infrastructure 實作 DB 與外部 API Adapter。

### 5.2 流程示意

```text
Controller
  -> Application Service
      -> Query Repository (DB)
      -> External API Client
      -> Merge / Mapping
      -> ApiResponse
```

---

## 6. 第一版建議實作範圍

1. Solution / Project 結構
2. `ApiResponse<T>` / `ApiError` / `PagedResult<T>`
3. `TraceIdMiddleware`
4. `RequestResponseLoggingMiddleware`
5. `ExceptionHandlingMiddleware`
6. `ApiRequestLog`
7. `ApiExceptionLog`
8. `Channel + BackgroundService`
9. Dapper DB Connection Factory
10. 基本 Query Repository / Application Service
11. Swagger

---

## 7. 第二版再補的項目

1. Body 遮罩 / 過濾策略
2. 特定 API 不記 body 的規則
3. 外部 API 共通治理
   - timeout
   - retry
   - circuit breaker
   - external API log
4. 驗證框架與統一驗證錯誤處理
5. 權限 / 驗證機制
6. `BusinessOperationLog`

---

## 8. 相關文件

- [project-structure.md](./project-structure.md)
- [../api/response-spec.md](../api/response-spec.md)
- [../logging/logging-and-trace-spec.md](../logging/logging-and-trace-spec.md)
