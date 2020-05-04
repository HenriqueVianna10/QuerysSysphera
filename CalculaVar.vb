public function CalculaVar(byval valorAtual as double, byval valorAnterior as double) as double

         if valorAnterior <> 0 then
	return (valorAtual /valorAnterior )-1
        else
	return 0
        end if
  
end function