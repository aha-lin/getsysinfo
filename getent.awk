#!/usr/bin/awk -f
BEGIN {print ENVIRON["var"]}

{
getline
while (1)
{
	starthere=0
	if ($0 ~ /^  ent.*Adapter/) 
#	if ($0 ~ /^  ent/) 
	{
		adapter_name=$1
		starthere=0	
		while (getline)
		{
			if ($0 ~ /FRU/) { print m_type,serial_no, adapter_name, substr($0,length($0)-6,7) ; break}
			if ($0 ~ /^  [a-zA-Z]/) { starthere=1;break } 

		}
	}
	else 
	{
		if (starthere==0)
		{
	   	if (getline) {} else break
		}
	}

}
}
