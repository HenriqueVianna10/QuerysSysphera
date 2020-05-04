Function SumLookup(ByVal items As Object()) As Decimal  
If items Is Nothing Then  
Return Nothing  
End If  
Dim suma As Decimal = New Decimal()  
Dim ct as Integer = New Integer()  
suma = 0  
ct = 0  
For Each item As Object In items  
suma += Convert.ToDecimal(item)  
ct += 1  
Next  
If (ct = 0) Then return 0 else return suma   
End Function