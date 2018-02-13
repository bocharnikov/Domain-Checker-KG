#!/bin/bash

#----------------------------------[ Copyright ]----------------------------------------+
#       Name: domain-checker-kg                                                         |
#       Author: Bocharnikov Sergei                                                      |
#       E-mail: bocharnikov@dezigner.ru                                                 |
#       Source: https://github.com/bocharnikov/                                         |
#                                                                                       |
#       Files: domain-checker-kg.sh                                                     |
#       Build: 130218                                                                   |
#       Copyright: 2018 Bocharnikov Sergei                                              |
#--------------------------------[ License: MIT ]---------------------------------------+
#                                                                                       |
#---------------------------------------------------------------------------------------+
#       Permission is hereby granted, free of charge, to any person obtaining a copy    |
#       of this software and associated documentation files (the "Software"), to deal   |
#       in the Software without restriction, including without limitation the rights    |
#       to use, copy, modify, merge, publish, distribute, sublicense, and/or sell       |
#       copies of the Software, and to permit persons to whom the Software is           |
#       furnished to do so, subject to the following conditions:                        |
#       The above copyright notice and this permission notice shall be included in all  |
#       copies or substantial portions of the Software.                                 |
#       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR      |
#       IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,        |
#       FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE     |
#       AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER          |
#       LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,   |
#       OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE   |
#       SOFTWARE.                                                                       |
#---------------------------------------------------------------------------------------+

# HTML REPORT
REPORT="/tmp/result_domain.html"

# PLEASE ENTER YOUR EMAIL ADDRESS
MYEMAIL="you@email.com"

# CHECK INPUT DOMAIN NAME
if [ "$1" == "" ]
then
cat << EOF

Пожалуйста, введите доменное имя в зоне KG.
Например: ./$(basename $0) alma.kg kt.kg fonex.kg

EOF
exit
fi

:> $REPORT

result="letsgo"

function letsgo() {
    curl -s 'https://www.cctld.kg/cgi-bin/r_whois.cgi' -H 'Host: www.cctld.kg' -H 'Referer: https://www.cctld.kg/rus/whois.html' --data "whois=${@^^}&next=" -k
}

for d in ${@^^}
do
    echo "----------------------------------------------------------------------"
    full_result=`letsgo $d`
    result=`echo "$full_result" | grep -i 'Срок действия заканчивается'`
    echo "$d - $result"

    get_result_date=`echo $result | cut -d\: -f2-`
    today=`date '+%s'`

    weeks=4
    chetiri_nedeli=$((( $weeks * 7 * 24 * 60 * 60 ))) # 4 недели в секундах
    date_diff=$(( $today - $( date '+%s' --date="$get_result_date" ) ))


# CLI COLOR MODE
    RESTORE=$(echo -en '\033[0m')
    GREEN=$(echo -en '\033[00;32m')
    #YELLOW=$(echo -en '\033[00;33m')
    RED=$(echo -en '\033[00;31m')

# PARSING STATUS DOMAIN
    STATUS_OK=`echo -en "Срок действия впорядке"`
    pr_result_0=`echo -en "$full_result" | grep -i 'ПРИОСТАНОВЛЕН до' | cut -d " " -f4-`
    pr_result_1=`echo -en "$full_result" | grep -i 'Информация'`
    STATUS_PROBLEM=`echo -en "${pr_result_0}${pr_result_1}"`

        if (( "$date_diff" <=! "$chetiri_nedeli" ))
        then
        htmlstatus=$STATUS_OK
            echo -e "Status: ${GREEN}$STATUS_OK${RESTORE}"
        else
        htmlstatus=$STATUS_PROBLEM
            echo -e "Status: ${RED}$STATUS_PROBLEM${RESTORE}"
        fi

# UNIX TIME DEBUG MODE
# echo -e "\n"
# echo -e "get_result_date ----> $(date '+%s' --date="$get_result_date")"
# echo -e "today --------------> $today"

    result_for_html=`echo -e "$result_for_html\n<br>$d - $result<br><b>Status: $htmlstatus</b><br><br>"`
    echo "----------------------------------------------------------------------"
done

# EMAIL FRAMEWORK
# http://emailframe.work
# https://github.com/g13nn/Email-Framework

cat > $REPORT <<EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>Domain Checker KG</title>

<style type="text/css">
/* Outlines the grid, remove when sending */
table td { border:1px solid lightgray; }

/* CLIENT-SPECIFIC STYLES */
body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
img { -ms-interpolation-mode: bicubic; }

/* RESET STYLES */
img { border: 0; outline: none; text-decoration: none; }
table { border-collapse: collapse !important; }
body { margin: 0 !important; padding: 0 !important; width: 100% !important; }

/* iOS BLUE LINKS */
a[x-apple-data-detectors] {
color: inherit !important;
text-decoration: none !important;
font-size: inherit !important;
font-family: inherit !important;
font-weight: inherit !important;
line-height: inherit !important;
}

/* ANDROID CENTER FIX */
div[style*="margin: 16px 0;"] { margin: 0 !important; }

/* MEDIA QUERIES */
@media all and (max-width:639px){ 
.wrapper{ width:320px!important; padding: 0 !important; }
.container{ width:300px!important;  padding: 0 !important; }
.mobile{ width:300px!important; display:block!important; padding: 0 !important; }
.img{ width:100% !important; height:auto !important; }
*[class="mobileOff"] { width: 0px !important; display: none !important; }
*[class*="mobileOn"] { display: block !important; max-height:none !important; }
}
</style>

</head>
<body style="margin:0; padding:0; background-color:#DCDCDC;">

<center>

<div style="background-color:#DCDCDC; max-width: 640px; margin: auto;">
<!--[if mso]>
<table role="presentation" width="640" cellspacing="0" cellpadding="0" border="0" align="center">
<tr>
<td>
<![endif]-->

<tr>
<td height="50" style="font-size:10px; line-height:10px;">&nbsp;</td>
</tr>

<img src="https://user-images.githubusercontent.com/35877180/36135341-94fff242-109b-11e8-9a21-6119f346433f.png" width="103" height="61" style="margin:0; padding:0; border:none; display:block;" border="0" class="imgClass" alt="Domain Checker KG" />
<tr>
    <td height="50" style="font-size:10px; line-height:10px;">&nbsp;</td>
</tr>

<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" bgcolor="#FFFFFF">
  <tr>
    <td align="left" valign="top" style="padding:20px;">
    $result_for_html
    </td>
  </tr>
</table>

<tr>
  <td height="10" style="font-size:42px; line-height:10px;">&nbsp;</td>
</tr>

<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" bgcolor="#E0E0E0">
  <tr>
    <td align="left" valign="top" style="padding:20px;">
    <p style="margin:0; padding:0; margin-bottom:15px;">Это сообщение не требует ответа.</p>
    Build: 130218. License: <a href="https://github.com/bocharnikov/Domain-Checker-KG/blob/master/LICENSE" target="_blank" style="color:#336699; text-decoration:underline;">MIT</a>. Copyright: 2018 Bocharnikov Sergei. Project <a href="https://github.com/bocharnikov/Domain-Checker-KG" target="_blank" style="color:#336699; text-decoration:underline;">page</a>.
    </td>
  </tr>
</table>

<tr>
    <td height="50" style="font-size:10px; line-height:10px;">&nbsp;</td>
</tr>

<table width="200" height="44" cellpadding="0" cellspacing="0" border="0" bgcolor="#2b3a63" style="border-radius:4px;">
  <tr>
    <td align="center" valign="middle" height="44" style="font-family: Arial, sans-serif; font-size:14px; font-weight:bold;">
    <a href="https://github.com/bocharnikov" target="_blank" style="font-family: Arial, sans-serif; color:#ffffff; display: inline-block; text-decoration: none; line-height:44px; width:200px; font-weight:bold;">Fork me on GitHub</a>
    </td>
  </tr>
</table>

</td>
</tr>
</table>

<tr>
    <td height="50" style="font-size:10px; line-height:10px;">&nbsp;</td>
</tr>

<!--[if mso]>
</td>
</tr>
</table>
<![endif]-->
</div>

</center>
</body>
</html>
EOF

mail -s "$(echo -e "Domain Checker KG\nContent-Type: text/html\nFrom: noreply \n";)" $MYEMAIL < $REPORT
