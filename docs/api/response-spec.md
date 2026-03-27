# Common API Response / Error Response 規格

## 1. 設計原則

- 成功與失敗共用同一個外框。
- `data` 只代表成功資料。
- `error` 只代表錯誤資訊。
- 每筆回應皆需包含可追蹤欄位。

---

## 2. 成功格式

```json
{
  "success": true,
  "timestamp": "2026-03-27T10:15:30Z",
  "traceId": "23ae70bb-497f-49df-adcc-b58e77fcae0a",
  "path": "/api/customers/1001",
  "method": "GET",
  "data": {
    "id": 1001,
    "name": "王小明"
  },
  "error": null
}
```

規則：

- `success = true`
- `data` 必須有值
- `error = null`

---

## 3. 失敗格式

```json
{
  "success": false,
  "timestamp": "2026-03-27T10:15:30Z",
  "traceId": "23ae70bb-497f-49df-adcc-b58e77fcae0a",
  "path": "/api/customers/1001",
  "method": "GET",
  "data": null,
  "error": {
    "code": "System.Unauthorized",
    "message": "請先登入後，再執行操作"
  }
}
```

規則：

- `success = false`
- `data = null`
- `error` 至少包含 `code` 與 `message`

---

## 4. 分頁格式

```json
{
  "success": true,
  "timestamp": "2026-03-27T10:15:30Z",
  "traceId": "23ae70bb-497f-49df-adcc-b58e77fcae0a",
  "path": "/api/customers",
  "method": "GET",
  "data": {
    "items": [],
    "page": 1,
    "pageSize": 10,
    "totalCount": 35,
    "totalPages": 4
  },
  "error": null
}
```

---

## 5. 驗證錯誤格式

```json
{
  "success": false,
  "timestamp": "2026-03-27T10:15:30Z",
  "traceId": "23ae70bb-497f-49df-adcc-b58e77fcae0a",
  "path": "/api/customers",
  "method": "POST",
  "data": null,
  "error": {
    "code": "Validation.Error",
    "message": "輸入資料驗證失敗",
    "details": [
      {
        "field": "name",
        "message": "姓名不可為空"
      }
    ]
  }
}
```

---

## 6. HTTP Status Code 建議

- `200`：成功查詢 / 成功更新
- `201`：新增成功
- `400`：驗證錯誤 / 請求格式錯誤
- `401`：未登入
- `403`：無權限
- `404`：查無資料
- `500`：系統錯誤

---

## 7. C# 共通 DTO 樣板

```csharp
public class ApiResponse<T>
{
    public bool Success { get; set; }
    public DateTime Timestamp { get; set; }
    public string TraceId { get; set; } = string.Empty;
    public string Path { get; set; } = string.Empty;
    public string Method { get; set; } = string.Empty;
    public T? Data { get; set; }
    public ApiError? Error { get; set; }
}

public class ApiError
{
    public string Code { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
    public object? Details { get; set; }
}

public class ValidationErrorDetail
{
    public string Field { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
}

public class PagedResult<T>
{
    public IReadOnlyList<T> Items { get; set; } = [];
    public int Page { get; set; }
    public int PageSize { get; set; }
    public int TotalCount { get; set; }
    public int TotalPages => PageSize <= 0 ? 0 : (int)Math.Ceiling((double)TotalCount / PageSize);
}
```

---

## 8. 相關文件

- [../architecture/overview.md](../architecture/overview.md)
- [../logging/logging-and-trace-spec.md](../logging/logging-and-trace-spec.md)
