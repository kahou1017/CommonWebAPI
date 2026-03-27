# Common API 待決議事項追蹤

本文件用於記錄「已討論但尚未正式定案」的主題，避免資訊遺失，並作為後續設計會議或文件修訂的延續依據。

## 使用原則

- 已正式定案的內容應寫入對應正式規格文件，不保留於本文件。
- 尚未定案但已經討論過的內容，應記錄於本文件。
- 每個待決議項目應至少包含：
  - 主題
  - 目前討論結論
  - 尚待確認事項
  - 建議下一步
- 若某項目後續已定案，應：
  1. 將正式內容移入對應規格文件
  2. 於本文件中標記為已完成或移除

---

## 狀態說明

- `Open`：已提出，但尚未定案
- `Discussing`：持續討論中
- `Deferred`：暫緩，留待後續版本
- `Closed`：已完成定案並移入正式文件

---

## 待決議清單

### 1. Token / Caller Identity 正式模型

- 狀態：`Discussing`
- 主題：
  - 未來將建立 token 產生管理網頁前端與 API 後端
  - 後續需決定 caller identity 的正式欄位與解析方式
- 目前討論結論：
  - 第一版 `ApiRequestLog` / `ApiExceptionLog` 暫不納入 `UserId`、`UserName`、`SourceSystem`
  - 未來可改為較中性的 caller 欄位，例如：
    - `CallerId`
    - `CallerName`
    - `SourceSystem`
    - `TokenId`
- 尚待確認事項：
  - token 格式與 claim 規格
  - caller identity 是否由 JWT / SSO / API Key 統一抽象
  - `SourceSystem` 是否來自 token、header 或 gateway
- 建議下一步：
  - 待 token 管理系統需求較完整後，再建立 `security/token-and-caller-strategy.md`

### 2. Body 遮罩與過濾策略

- 狀態：`Deferred`
- 主題：
  - 第一版 `RequestBody` / `ResponseBody` 採完整記錄
  - 需保留未來對敏感欄位進行遮罩或摘要化的能力
- 目前討論結論：
  - 第一版先全存
  - 已保留 `BodyStoredMode` 作為擴充欄位
- 尚待確認事項：
  - 哪些欄位屬於敏感資料
  - 是否依 API 路徑、欄位名稱或設定檔決定遮罩策略
  - 是否需支援只在錯誤時完整記錄
- 建議下一步：
  - 後續建立 `IBodyLogProcessor` 規格與 masking policy 文件

### 3. DB Log 寫入失敗的重試策略

- 狀態：`Discussing`
- 主題：
  - 是否在第一版或後續版本對 DB log 寫入失敗進行重試
- 目前討論結論：
  - 第一版先不實作 retry
  - 目前規格為：寫入失敗只記本地 error log，不影響主流程
- 尚待確認事項：
  - 何種錯誤屬於可重試錯誤
  - 最大重試次數與退避策略
  - 是否以重新 enqueue 或 consumer 內部 retry 實作
- 建議下一步：
  - 後續若要提升可靠性，可新增 retry policy 文件並更新 logging 規格

### 4. API 服務離線後的 DB Log 保留能力

- 狀態：`Deferred`
- 主題：
  - API 服務離線、重啟或 crash 時，記憶體 queue 中尚未落庫的 DB log 可能遺失
- 目前討論結論：
  - 第一版接受少量 DB log 遺失
  - 本地 log 為保底追蹤來源
- 尚待確認事項：
  - 是否需要本地持久化暫存
  - 是否要升級為 durable queue 或外部 MQ
  - 是否需要服務重啟後補寫機制
- 建議下一步：
  - 若後續對 log 完整性要求提升，再評估建立 durable logging 設計文件

### 5. External API Call Log 是否納入第二版

- 狀態：`Open`
- 主題：
  - 外部 API 呼叫是否需建立獨立 `ExternalApiCallLog`
- 目前討論結論：
  - 已認同未來有價值，但尚未納入第一版正式規格
- 尚待確認事項：
  - 第二版是否納入
  - 欄位結構與 `TraceId` / `OutgoingTraceId` 關聯方式
  - 是否需要記 request/response body 與耗時
- 建議下一步：
  - 待外部 API 整合規格開始設計時一併定案
