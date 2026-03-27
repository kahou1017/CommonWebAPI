# Logging SQL 與 C# Entity / DTO 對應表

本文件整理 `ApiRequestLog` 與 `ApiExceptionLog` 的 SQL Server 欄位與 C# Entity / DTO 對應，作為後續實作 Middleware、Repository 與 Dapper Mapping 的依據。

---

## 1. ApiRequestLog 對應表

| SQL 欄位 | SQL 型別 | Null | C# 型別 | C# 屬性名稱 | 說明 |
|---|---|---:|---|---|---|
| `Id` | `bigint identity(1,1)` | 否 | `long` | `Id` | 主鍵 |
| `TraceId` | `nvarchar(36)` | 否 | `string` | `TraceId` | 系統主追蹤碼 |
| `IncomingTraceId` | `nvarchar(256)` | 是 | `string?` | `IncomingTraceId` | 上游傳入追蹤碼 |
| `OutgoingTraceId` | `nvarchar(36)` | 是 | `string?` | `OutgoingTraceId` | 對外呼叫追蹤碼，第一版可空 |
| `RequestTimeUtc` | `datetime2(3)` | 否 | `DateTime` | `RequestTimeUtc` | Request 開始時間 |
| `ResponseTimeUtc` | `datetime2(3)` | 是 | `DateTime?` | `ResponseTimeUtc` | Response 完成時間 |
| `ElapsedMs` | `int` | 是 | `int?` | `ElapsedMs` | 執行耗時毫秒 |
| `Success` | `bit` | 否 | `bool` | `Success` | 是否成功 |
| `HttpStatusCode` | `int` | 否 | `int` | `HttpStatusCode` | HTTP 狀態碼 |
| `Method` | `nvarchar(10)` | 否 | `string` | `Method` | HTTP Method |
| `Path` | `nvarchar(500)` | 否 | `string` | `Path` | API 路徑 |
| `QueryString` | `nvarchar(max)` | 是 | `string?` | `QueryString` | QueryString |
| `RequestContentType` | `nvarchar(100)` | 是 | `string?` | `RequestContentType` | Request Content-Type |
| `ResponseContentType` | `nvarchar(100)` | 是 | `string?` | `ResponseContentType` | Response Content-Type |
| `UserAgent` | `nvarchar(1000)` | 是 | `string?` | `UserAgent` | 呼叫端 User-Agent |
| `ClientIp` | `nvarchar(50)` | 是 | `string?` | `ClientIp` | 呼叫端 IP |
| `RequestBody` | `nvarchar(max)` | 是 | `string?` | `RequestBody` | Request Body |
| `ResponseBody` | `nvarchar(max)` | 是 | `string?` | `ResponseBody` | Response Body |
| `BodyStoredMode` | `nvarchar(20)` | 否 | `string` 或 `BodyStoredMode` | `BodyStoredMode` | Body 記錄模式 |
| `ErrorCode` | `nvarchar(100)` | 是 | `string?` | `ErrorCode` | 錯誤代碼 |
| `ErrorMessage` | `nvarchar(1000)` | 是 | `string?` | `ErrorMessage` | 錯誤訊息摘要 |
| `MachineName` | `nvarchar(100)` | 是 | `string?` | `MachineName` | 主機名稱 |
| `EnvironmentName` | `nvarchar(50)` | 是 | `string?` | `EnvironmentName` | 環境名稱 |
| `CreatedAtUtc` | `datetime2(3)` | 否 | `DateTime` | `CreatedAtUtc` | 建立時間 |

---

## 2. ApiExceptionLog 對應表

| SQL 欄位 | SQL 型別 | Null | C# 型別 | C# 屬性名稱 | 說明 |
|---|---|---:|---|---|---|
| `Id` | `bigint identity(1,1)` | 否 | `long` | `Id` | 主鍵 |
| `TraceId` | `nvarchar(36)` | 否 | `string` | `TraceId` | 系統主追蹤碼 |
| `IncomingTraceId` | `nvarchar(256)` | 是 | `string?` | `IncomingTraceId` | 上游傳入追蹤碼 |
| `OutgoingTraceId` | `nvarchar(36)` | 是 | `string?` | `OutgoingTraceId` | 對外呼叫追蹤碼，第一版可空 |
| `OccurredAtUtc` | `datetime2(3)` | 否 | `DateTime` | `OccurredAtUtc` | 例外發生時間 |
| `Method` | `nvarchar(10)` | 是 | `string?` | `Method` | HTTP Method |
| `Path` | `nvarchar(500)` | 是 | `string?` | `Path` | API 路徑 |
| `HttpStatusCode` | `int` | 是 | `int?` | `HttpStatusCode` | HTTP 狀態碼 |
| `ClientIp` | `nvarchar(50)` | 是 | `string?` | `ClientIp` | 呼叫端 IP |
| `ExceptionType` | `nvarchar(500)` | 否 | `string` | `ExceptionType` | 例外型別 |
| `Message` | `nvarchar(2000)` | 否 | `string` | `Message` | 例外訊息 |
| `StackTrace` | `nvarchar(max)` | 是 | `string?` | `StackTrace` | 堆疊資訊 |
| `InnerException` | `nvarchar(max)` | 是 | `string?` | `InnerException` | 內層例外摘要 |
| `RequestBody` | `nvarchar(max)` | 是 | `string?` | `RequestBody` | Request Body |
| `AdditionalData` | `nvarchar(max)` | 是 | `string?` | `AdditionalData` | 補充 JSON/文字 |
| `MachineName` | `nvarchar(100)` | 是 | `string?` | `MachineName` | 主機名稱 |
| `EnvironmentName` | `nvarchar(50)` | 是 | `string?` | `EnvironmentName` | 環境名稱 |
| `CreatedAtUtc` | `datetime2(3)` | 否 | `DateTime` | `CreatedAtUtc` | 建立時間 |

---

## 3. 建議 C# Entity

```csharp
public class ApiRequestLog
{
    public long Id { get; set; }
    public string TraceId { get; set; } = string.Empty;
    public string? IncomingTraceId { get; set; }
    public string? OutgoingTraceId { get; set; }
    public DateTime RequestTimeUtc { get; set; }
    public DateTime? ResponseTimeUtc { get; set; }
    public int? ElapsedMs { get; set; }
    public bool Success { get; set; }
    public int HttpStatusCode { get; set; }
    public string Method { get; set; } = string.Empty;
    public string Path { get; set; } = string.Empty;
    public string? QueryString { get; set; }
    public string? RequestContentType { get; set; }
    public string? ResponseContentType { get; set; }
    public string? UserAgent { get; set; }
    public string? ClientIp { get; set; }
    public string? RequestBody { get; set; }
    public string? ResponseBody { get; set; }
    public string BodyStoredMode { get; set; } = "Full";
    public string? ErrorCode { get; set; }
    public string? ErrorMessage { get; set; }
    public string? MachineName { get; set; }
    public string? EnvironmentName { get; set; }
    public DateTime CreatedAtUtc { get; set; }
}

public class ApiExceptionLog
{
    public long Id { get; set; }
    public string TraceId { get; set; } = string.Empty;
    public string? IncomingTraceId { get; set; }
    public string? OutgoingTraceId { get; set; }
    public DateTime OccurredAtUtc { get; set; }
    public string? Method { get; set; }
    public string? Path { get; set; }
    public int? HttpStatusCode { get; set; }
    public string? ClientIp { get; set; }
    public string ExceptionType { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
    public string? StackTrace { get; set; }
    public string? InnerException { get; set; }
    public string? RequestBody { get; set; }
    public string? AdditionalData { get; set; }
    public string? MachineName { get; set; }
    public string? EnvironmentName { get; set; }
    public DateTime CreatedAtUtc { get; set; }
}
```

---

## 4. BodyStoredMode 建議

第一版可先以 `string` 實作，直接對應 DB constraint。

若後續希望在 C# 端加強型別安全，可改用 enum，例如：

```csharp
public enum BodyStoredMode
{
    Full = 1,
    Masked = 2,
    Summary = 3,
    Excluded = 4
}
```

---

## 5. 相關文件

- [logging-and-trace-spec.md](./logging-and-trace-spec.md)
- [../../sql/logging/create-api-request-log.sql](../../sql/logging/create-api-request-log.sql)
- [../../sql/logging/create-api-exception-log.sql](../../sql/logging/create-api-exception-log.sql)
