CREATE TABLE dbo.ApiExceptionLog
(
    Id BIGINT IDENTITY(1,1) NOT NULL,
    TraceId NVARCHAR(36) NOT NULL,
    IncomingTraceId NVARCHAR(256) NULL,
    OutgoingTraceId NVARCHAR(36) NULL,
    OccurredAtUtc DATETIME2(3) NOT NULL,
    Method NVARCHAR(10) NULL,
    Path NVARCHAR(500) NULL,
    HttpStatusCode INT NULL,
    ClientIp NVARCHAR(50) NULL,
    ExceptionType NVARCHAR(500) NOT NULL,
    Message NVARCHAR(2000) NOT NULL,
    StackTrace NVARCHAR(MAX) NULL,
    InnerException NVARCHAR(MAX) NULL,
    RequestBody NVARCHAR(MAX) NULL,
    AdditionalData NVARCHAR(MAX) NULL,
    MachineName NVARCHAR(100) NULL,
    EnvironmentName NVARCHAR(50) NULL,
    CreatedAtUtc DATETIME2(3) NOT NULL CONSTRAINT DF_ApiExceptionLog_CreatedAtUtc DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_ApiExceptionLog PRIMARY KEY CLUSTERED (Id ASC)
);
GO

CREATE NONCLUSTERED INDEX IX_ApiExceptionLog_TraceId
    ON dbo.ApiExceptionLog (TraceId);
GO

CREATE NONCLUSTERED INDEX IX_ApiExceptionLog_OccurredAtUtc
    ON dbo.ApiExceptionLog (OccurredAtUtc);
GO

CREATE NONCLUSTERED INDEX IX_ApiExceptionLog_ExceptionType_OccurredAtUtc
    ON dbo.ApiExceptionLog (ExceptionType, OccurredAtUtc);
GO
