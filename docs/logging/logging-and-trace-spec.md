# Common API Logging / Trace 規格

## 1. 目標

- 可追蹤每次 API 的 Request / Response。
- 可依 `TraceId` 回查完整問題。
- 支援本地 Log 與 DB Log。
- 避免 DB Log 寫入影響主流程。

---

## 2. Log 分流

### 2.1 本地 Log

用途：

- 除錯
- 效能分析
- 例外堆疊
- 開發 / 維運追查

### 2.2 DB Log

用途：

- API 呼叫追蹤
- 問題回溯
- Request / Response 查詢
- 稽核與介接確認

---

## 3. Trace 規格

### 3.1 TraceId 原則

- 每個 HTTP Request 都必須有系統內部使用的 `TraceId`
- `TraceId` 一律由 Server 端產生
- 若 Request Header 含 `X-Trace-Id`，則記錄於 `IncomingTraceId`
- `IncomingTraceId` 僅用於保留上游系統傳入的追蹤資訊，不作為本系統主追蹤碼
- 若本系統需呼叫外部 API，則可帶出 `OutgoingTraceId`
- 第一版中，`OutgoingTraceId` 預設採用 `TraceId`
- `TraceId` 必須寫入：
  - Response Header
  - API Response Body
  - Local Log
  - DB Log
  - Exception Log

### 3.2 Trace 欄位定義

#### `TraceId`

- 本系統主追蹤碼
- 由 Server 端產生
- 採用 GUID 字串格式
- 使用小寫字母與連字號
- 第一版長度固定為 36 碼
- 用於串接本系統內所有 request / response / log / exception

#### `IncomingTraceId`

- 記錄上游系統傳入的 `X-Trace-Id`
- 不限制格式，原樣保留
- 可能為空值
- 第一版建議欄位長度至少為 256，以避免上游系統追蹤碼長度不足
- 用於跨系統問題追查

#### `OutgoingTraceId`

- 本系統對外呼叫 API 時帶出的追蹤碼
- 第一版預設使用 `TraceId`
- 後續若有需要，可擴充為每次外呼產生獨立追蹤碼

### 3.3 與平台追蹤整合的保留策略

- 第一版主追蹤欄位仍以 `TraceId` 為主
- 可保留 `Activity.TraceId` 的整合空間，以利未來與平台監控、APM 或 OpenTelemetry 整合
- 第一版不強制將 `Activity.TraceId` 納入正式 API 回應或 DB log 欄位
- 後續若平台整合需求明確，可再評估：
  - 是否新增 `PlatformTraceId`
  - 是否直接對應 W3C Trace Context / `traceparent`
  - 是否建立與 `TraceId` 的對照規則

---

## 4. Body Logging Policy

### 4.1 現行策略

- 第一版採 `RequestBody` / `ResponseBody` 完整記錄。
- 目標是先建立完整問題追查能力。

### 4.2 擴充策略

系統需保留後續調整能力，支援：

- 欄位遮罩
- 特定 API 排除記錄
- 僅記摘要
- 僅錯誤時記完整內容

### 4.3 設計要求

- Middleware 中需預留 Body Processor 擴充點。
- 未來若需遮罩或特殊處理，不應影響主流程架構。

---

## 5. ApiRequestLog / ApiExceptionLog 記錄原則

### 5.1 `ApiRequestLog` 記錄原則

- 每一個 API Request 均需記錄一筆 `ApiRequestLog`
- 不論成功或失敗，皆需記錄
- 記錄時機為 Response 完成後
- 若發生未處理例外，仍應保留該次 `ApiRequestLog`
- `ApiRequestLog` 為 API 呼叫主紀錄
- 第一版預設全記錄，後續可依需求增加排除清單，例如：
  - `/health`
  - `/swagger`
  - 其他非業務性路徑

#### `ApiRequestLog` 欄位角色

- 用於查詢每次 API 呼叫的完整過程
- 可查 request / response / status code / success / elapsed time / client / trace 資訊

### 5.2 `ApiRequestLog` 成功判斷原則

- 第一版採用簡化規則：
  - `HttpStatusCode < 400` 視為成功
  - `HttpStatusCode >= 400` 視為失敗

### 5.3 `ApiExceptionLog` 記錄原則

- `ApiExceptionLog` 僅用於記錄未處理例外（Unhandled Exception）
- 驗證錯誤、授權失敗、查無資料、業務規則錯誤等可預期錯誤，不另寫入 `ApiExceptionLog`
- 上述可預期錯誤應透過 `ApiRequestLog` 的 `HttpStatusCode`、`ErrorCode`、`ErrorMessage` 與 `ResponseBody` 追查
- `ApiExceptionLog` 為例外補充紀錄，不取代 `ApiRequestLog`

#### `ApiExceptionLog` 欄位角色

- 用於查詢未處理例外的技術細節
- 可查 exception type / message / stack trace / inner exception / trace 關聯資訊

### 5.4 記錄角色分工

#### `ApiRequestLog`

- API 呼叫主紀錄
- 每次都記錄
- 用於查詢 API 呼叫事實與輸出結果

#### `ApiExceptionLog`

- 系統例外補充紀錄
- 僅在未處理例外時記錄
- 用於技術診斷與錯誤根因分析

### 5.5 第一版 Caller / Source 欄位策略

- 第一版 `ApiRequestLog` 與 `ApiExceptionLog` 先不納入 `UserId`、`UserName`、`SourceSystem`
- 原因如下：
  - 目前尚未建立正式的 token 管理與 caller identity 規格
  - 第一版先優先完成 API 主追蹤與 request / response 記錄能力
  - 避免在 caller identity 尚未明確前，先設計過度假設的欄位
- 第一版改以以下欄位協助辨識呼叫來源：
  - `TraceId`
  - `IncomingTraceId`
  - `ClientIp`
  - `UserAgent`
- 後續若完成 token 管理前端 / API 後端設計，可再評估新增：
  - `CallerId`
  - `CallerName`
  - `SourceSystem`
  - `TokenId`

---

## 6. Background Log Queue 設計

### 6.1 第一版技術

- `System.Threading.Channels`
- `BackgroundService`

### 6.2 設計原則

- API 主流程不直接同步寫 DB Log
- 第一版 queue 僅處理：
  - `ApiRequestLog`
  - `ApiExceptionLog`
- Middleware / Service 建立 Log Entry 後先 enqueue
- BackgroundService 負責 dequeue 並寫入 DB
- enqueue 失敗不得影響 API 主流程，但必須寫入本地 Error Log
- DB 寫入失敗不得回頭影響已完成的 API Response
- 第一版 DB 寫入失敗僅寫入本地 Error Log，不實作 retry
- 第一版採單機記憶體 queue，不提供跨機持久化保證

### 6.3 流程圖

```text
Middleware / Service
  -> enqueue log item
  -> Channel
  -> BackgroundService dequeue
  -> write DB
```

### 6.4 Queue Item 設計要求

- Queue Item 必須具備類型資訊，以區分不同 log 類別
- Queue Item 必須記錄 enqueue 時間，以便觀察背景寫入延遲

建議欄位：

- `Category`
- `Payload`
- `EnqueuedAtUtc`

### 6.5 第一版範圍

第一版需具備：

- `Channel`
- `BackgroundService`
- `LogQueueItem`
- `LogCategory`
- enqueue / dequeue 機制
- DB 寫入失敗本地記錄
- 系統關閉時盡可能 drain queue

第一版先不實作：

- retry
- dead-letter
- 批次寫入
- durable queue
- 分散式 message broker

### 6.6 後續升級方向

若未來流量或多節點需求提升，可再評估：

- Hangfire
- RabbitMQ
- Kafka
- Azure Service Bus

### 6.7 API 服務離線情境下的 Logging 原則

- 第一版 `Background Log Queue` 採用記憶體內 queue
- 若 API 服務異常中止、重啟或離線，尚未寫入 DB 的 log 可能遺失
- 第一版接受少量 DB log 遺失風險
- 本地 Log 為第一版的保底追蹤來源，必須確保可查詢與可保留
- DB Log 為追蹤與查詢輔助資料來源，不可反向影響 API 主流程
- 後續若需提升可靠性，可再升級為：
  - 本地持久化暫存
  - durable queue
  - 外部 MQ

---

## 7. DB Log 資料表

### 7.1 `ApiRequestLog`

用途：

- 記錄每次 API 的 request / response 摘要與結果

主要欄位：

- `TraceId`
- `IncomingTraceId`
- `OutgoingTraceId`
- `RequestTimeUtc`
- `ResponseTimeUtc`
- `ElapsedMs`
- `Success`
- `HttpStatusCode`
- `Method`
- `Path`
- `QueryString`
- `RequestContentType`
- `ResponseContentType`
- `UserAgent`
- `ClientIp`
- `RequestBody`
- `ResponseBody`
- `BodyStoredMode`
- `ErrorCode`
- `ErrorMessage`
- `MachineName`
- `EnvironmentName`
- `CreatedAtUtc`

補充規則：

- 第一版先保留 `OutgoingTraceId` 欄位，作為未來外部 API 追蹤延伸使用
- 第一版若無外部 API 呼叫情境，`OutgoingTraceId` 可為空值
- `BodyStoredMode` 第一版預設採用 `Full`
- `BodyStoredMode` 建議以 check constraint 限制允許值：
  - `Full`
  - `Masked`
  - `Summary`
  - `Excluded`

### 7.2 `ApiExceptionLog`

用途：

- 記錄未處理例外與錯誤細節

主要欄位：

- `TraceId`
- `IncomingTraceId`
- `OutgoingTraceId`
- `OccurredAtUtc`
- `Method`
- `Path`
- `HttpStatusCode`
- `ClientIp`
- `ExceptionType`
- `Message`
- `StackTrace`
- `InnerException`
- `RequestBody`
- `AdditionalData`
- `MachineName`
- `EnvironmentName`
- `CreatedAtUtc`

補充規則：

- 第一版先保留 `OutgoingTraceId` 欄位，作為未來外部 API 追蹤延伸使用
- 第一版若本次例外並未涉及外部 API 呼叫，`OutgoingTraceId` 可為空值

### 7.3 `BusinessOperationLog`

目前結論：

- 架構上保留概念
- 第一版暫不實作

### 7.4 SQL 建表檔案位置

- `ApiRequestLog` 建表 SQL：
  - [../../sql/logging/create-api-request-log.sql](../../sql/logging/create-api-request-log.sql)
- `ApiExceptionLog` 建表 SQL：
  - [../../sql/logging/create-api-exception-log.sql](../../sql/logging/create-api-exception-log.sql)

---

## 8. Middleware 標準模組

### 8.1 `TraceIdMiddleware`

負責：

- 讀取或產生 `TraceId`
- 寫入 `HttpContext`
- 寫入 Response Header

### 8.2 `RequestResponseLoggingMiddleware`

負責：

- 讀取 RequestBody
- 擷取 ResponseBody
- 計算耗時
- 寫本地 Log
- enqueue `ApiRequestLog`

### 8.3 `ExceptionHandlingMiddleware`

負責：

- 捕捉未處理例外
- 寫本地 Error Log
- enqueue `ApiExceptionLog`
- 輸出統一錯誤格式

---

## 9. 相關文件

- [../architecture/overview.md](../architecture/overview.md)
- [../api/response-spec.md](../api/response-spec.md)
