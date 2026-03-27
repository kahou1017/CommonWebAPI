# Common API 專案結構與命名規範

## 1. Solution / 專案結構

```text
src/
  CommonApi.Api/
  CommonApi.Application/
  CommonApi.Domain/
  CommonApi.Infrastructure/
  CommonApi.Contracts/

tests/
  CommonApi.UnitTests/
  CommonApi.IntegrationTests/
```

## 2. 各專案職責

### `CommonApi.Api`

- Controllers
- Middleware
- Filters
- Swagger
- DI 註冊入口

### `CommonApi.Application`

- Use Cases / Services
- DTO
- Validators
- 介面契約
- 流程協調

### `CommonApi.Domain`

- Entities
- Enums
- Constants
- Exceptions
- Value Objects

### `CommonApi.Infrastructure`

- Dapper 實作
- DB Connection Factory
- 外部 API Client
- Logging / Audit
- Queue / BackgroundService

### `CommonApi.Contracts`

- ApiResponse
- ApiError
- PagedResult
- 共通 Request/Response Contract
- Tracing Contract

---

## 3. 目錄建議

### 3.1 `CommonApi.Api`

```text
Controllers/
Middleware/
Filters/
Extensions/
Configurations/
```

### 3.2 `CommonApi.Application`

```text
Abstractions/
Dtos/
Features/
Services/
Validators/
```

功能導向切法：

```text
Features/
  Customers/
    Queries/
    Commands/
    Dtos/
    Interfaces/
```

### 3.3 `CommonApi.Domain`

```text
Entities/
Enums/
Constants/
Exceptions/
ValueObjects/
```

### 3.4 `CommonApi.Infrastructure`

```text
Persistence/
  Connections/
  Queries/
  Commands/
Integrations/
  ProductApi/
    Clients/
    Dtos/
    Mappers/
Logging/
  Queue/
  Entities/
  Repositories/
Audit/
DependencyInjection/
```

### 3.5 `CommonApi.Contracts`

```text
Responses/
Paging/
Tracing/
```

---

## 4. 命名原則

### 4.1 Repository / Client 命名

- DB Query：`ICustomerQueryRepository`
- DB Command：`ICustomerCommandRepository`
- 外部 API：`ICustomerProfileApiClient`
- Application：`ICustomerQueryService`

### 4.2 設計原則

- 功能導向優先於技術導向。
- `Application` 只定義能力與流程，不綁定實作技術。
- `Infrastructure` 明確區分：
  - `Persistence`
  - `Integrations`
  - `Logging`

---

## 5. 相關文件

- [overview.md](./overview.md)
- [../api/response-spec.md](../api/response-spec.md)
- [../logging/logging-and-trace-spec.md](../logging/logging-and-trace-spec.md)
