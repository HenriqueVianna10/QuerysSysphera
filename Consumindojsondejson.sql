SELECT 
    a.GLAccount,
    a.IsBalanceSheetAccount,
    a.CreationDate,
    a.CreatedByUser,
    a.IsProfitLossAccount,
    a.AccountIsBlockedForCreation,
    a.ChartOfAccounts,
    a.GLAccountGroup,
    a.GLAccountType,
    t.Language,
    t.GLAccountName,
    t.GLAccountLongName
FROM OPENJSON(@json, '$.A_GLAccountInChartOfAccounts.A_GLAccountInChartOfAccountsType')
WITH (
    GLAccount NVARCHAR(50) '$.GLAccount',
    IsBalanceSheetAccount NVARCHAR(10) '$.IsBalanceSheetAccount',
    CreationDate DATETIME '$.CreationDate',
    CreatedByUser NVARCHAR(50) '$.CreatedByUser',
    IsProfitLossAccount NVARCHAR(10) '$.IsProfitLossAccount',
    AccountIsBlockedForCreation NVARCHAR(10) '$.AccountIsBlockedForCreation',
    ChartOfAccounts NVARCHAR(50) '$.ChartOfAccounts',
    GLAccountGroup NVARCHAR(50) '$.GLAccountGroup',
    GLAccountType NVARCHAR(50) '$.GLAccountType',
    to_Text NVARCHAR(MAX) '$.to_Text' AS JSON
) AS a
CROSS APPLY OPENJSON(a.to_Text, '$.A_GLAccountTextType')
WITH (
    Language NVARCHAR(10) '$.Language',
    GLAccountName NVARCHAR(100) '$.GLAccountName',
    GLAccountLongName NVARCHAR(255) '$.GLAccountLongName'
) AS t;