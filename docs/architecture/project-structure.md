# Common API 撠?蝯????蝭?

## 1. Solution / 撠?蝯?

```text
src/
  CommonWebApi.Api/
  CommonWebApi.Application/
  CommonWebApi.Domain/
  CommonWebApi.Infrastructure/
  CommonWebApi.Contracts/

tests/
  CommonWebApi.UnitTests/
  CommonWebApi.IntegrationTests/
```

## 2. ??獢鞎?

### `CommonWebApi.Api`

- Controllers
- Middleware
- Filters
- Swagger
- DI 閮餃??亙

### `CommonWebApi.Application`

- Use Cases / Services
- DTO
- Validators
- 隞憟?
- 瘚??矽

### `CommonWebApi.Domain`

- Entities
- Enums
- Constants
- Exceptions
- Value Objects

### `CommonWebApi.Infrastructure`

- Dapper 撖虫?
- DB Connection Factory
- 憭 API Client
- Logging / Audit
- Queue / BackgroundService

### `CommonWebApi.Contracts`

- ApiResponse
- ApiError
- PagedResult
- ?梢?Request/Response Contract
- Tracing Contract

---

## 3. ?桅?撱箄降

### 3.1 `CommonWebApi.Api`

```text
Controllers/
Middleware/
Filters/
Extensions/
Configurations/
```

### 3.2 `CommonWebApi.Application`

```text
Abstractions/
Dtos/
Features/
Services/
Validators/
```

?撠???嚗?

```text
Features/
  Customers/
    Queries/
    Commands/
    Dtos/
    Interfaces/
```

### 3.3 `CommonWebApi.Domain`

```text
Entities/
Enums/
Constants/
Exceptions/
ValueObjects/
```

### 3.4 `CommonWebApi.Infrastructure`

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

### 3.5 `CommonWebApi.Contracts`

```text
Responses/
Paging/
Tracing/
```

---

## 4. ?賢???

### 4.1 Repository / Client ?賢?

- DB Query嚗ICustomerQueryRepository`
- DB Command嚗ICustomerCommandRepository`
- 憭 API嚗ICustomerProfileApiClient`
- Application嚗ICustomerQueryService`

### 4.2 閮剛???

- ?撠??芸??潭?銵???
- `Application` ?芸?蝢抵??瘚?嚗?蝬?撖虫??銵?
- `Infrastructure` ?Ⅱ???
  - `Persistence`
  - `Integrations`
  - `Logging`

---

## 5. ?賊??辣

- [overview.md](./overview.md)
- [../api/response-spec.md](../api/response-spec.md)
- [../logging/logging-and-trace-spec.md](../logging/logging-and-trace-spec.md)

