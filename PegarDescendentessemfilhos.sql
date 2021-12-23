select sk_conta from d_conta_app1
where sk_conta not in (select ISNULL(sk_parent,0) from d_conta_app1)
and sk_conta_l3 = 8

