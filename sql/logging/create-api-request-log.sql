CREATE TABLE dbo.ApiRequestLog
(
    Id BIGINT IDENTITY(1,1) NOT NULL,
    TraceId NVARCHAR(36) NOT NULL,
    IncomingTraceId NVARCHAR(256) NULL,
    OutgoingTraceId NVARCHAR(36) NULL,
    RequestTimeUtc DATETIME2(3) NOT NULL,
    ResponseTimeUtc DATETIME2(3) NULL,
    ElapsedMs INT NULL,
    Success BIT NOT NULL,
    HttpStatusCode INT NOT NULL,
    Method NVARCHAR(10) NOT NULL,
    Path NVARCHAR(500) NOT NULL,
    QueryString NVARCHAR(MAX) NULL,
    RequestContentType NVARCHAR(100) NULL,
    ResponseContentType NVARCHAR(100) NULL,
    UserAgent NVARCHAR(1000) NULL,
    ClientIp NVARCHAR(50) NULL,
    RequestBody NVARCHAR(MAX) NULL,
    ResponseBody NVARCHAR(MAX) NULL,
    BodyStoredMode NVARCHAR(20) NOT NULL CONSTRAINT DF_ApiRequestLog_BodyStoredMode DEFAULT (N'Full'),
    ErrorCode NVARCHAR(100) NULL,
    ErrorMessage NVARCHAR(1000) NULL,
    MachineName NVARCHAR(100) NULL,
    EnvironmentName NVARCHAR(50) NULL,
    CreatedAtUtc DATETIME2(3) NOT NULL CONSTRAINT DF_ApiRequestLog_CreatedAtUtc DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_ApiRequestLog PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT CK_ApiRequestLog_BodyStoredMode CHECK (BodyStoredMode IN (N'Full', N'Masked', N'Summary', N'Excluded'))
);
GO

CREATE NONCLUSTERED INDEX IX_ApiRequestLog_TraceId
    ON dbo.ApiRequestLog (TraceId);
GO

CREATE NONCLUSTERED INDEX IX_ApiRequestLog_RequestTimeUtc
    ON dbo.ApiRequestLog (RequestTimeUtc);
GO

CREATE NONCLUSTERED INDEX IX_ApiRequestLog_Path_RequestTimeUtc
    ON dbo.ApiRequestLog (Path, RequestTimeUtc);
GO

CREATE NONCLUSTERED INDEX IX_ApiRequestLog_Success_RequestTimeUtc
    ON dbo.ApiRequestLog (Success, RequestTimeUtc);
GO
