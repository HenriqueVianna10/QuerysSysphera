INSERT INTO DBO.REP_DATALOAD_REST (dscName,jsnParameter) values ('TesteHenriqueZenith',
N'{
"Url":"http://10.100.1.41:9999/ERPIntegration",
"Header":"Host:10.100.1.41:9999; Accept:*/*; Connection:keep-alive; Content-Type:text/xml; SOAPAction:\"http%3A%2F%2Ftempuri.org%2FIZenithERPIntegration%2FGetListaConsultaTalhao\"",
"RequestMethod":"POST",
"Body":"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">
    <soapenv:Header/>
    <soapenv:Body>
        <tem:GetListaConsultaTalhao/>
    </soapenv:Body>
</soapenv:Envelope>"
}')


