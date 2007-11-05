Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbXKEKBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbXKEKBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXKEKBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:01:35 -0500
Received: from n7.bullet.mud.yahoo.com ([216.252.100.58]:28330 "HELO
	n7.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752871AbXKEKBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:01:35 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 392989.30968.bm@omp106.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ng4kQyqnC2NdQpMOT5vZRBk+XIEdPisPyC4hie7qOO5TbaZkwnpMuo1S4C2gnShfYfioaguLvqJrC6WuWtP84/kI453gu7QKXfHjfK075BocI2QbZUpIZP3c2GmRPw18X/+G0q+cDlXuyd2bqP26DCL3y4g6tADsotMTl33bdfY=;
X-YMail-OSG: zfKk4pUVM1k7P1UoheFrliF17TB3IPykPkr4pi11.1g9qfDWQLfDV_BkSzDMIC6gTZYEdKfS8ZdmJNitjLEblqwa0y6fD2MbzyNXj8ACWbY8cWPFcXo-
X-Mailer: YahooMailRC/814.06 YahooMailWebService/0.7.152
Date: Mon, 5 Nov 2007 15:31:32 +0530 (IST)
From: veerasena reddy <veerasena_b@yahoo.co.in>
Subject: Re: NPTL support
To: Markus Gothe <markus.gothe@27m.se>
Cc: uclibc@uclibc.org, linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>, buildroot@uclibc.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <279675.30374.qm@web8411.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

thanks for the information.

i checked out uclibc-nptl (version 0.9.29). is it a stable release?
If i want to build toolchain using buildroot with nptl support for linux kernel 2.6.18.8, could you please guide us the right version of buildroot, binutils, and gcc to be used.

Thanks & Regards,
Veerasena.

----- Original Message ----
From: Markus Gothe <markus.gothe@27m.se>
To: veerasena reddy <veerasena_b@yahoo..co.in>
Cc: uclibc@uclibc.org; linux-mips <linux-mips@linux-mips.org>; linux-kernel.org <linux-kernel@vger.kernel.org>; buildroot@uclibc.org
Sent: Friday, 2 November, 2007 6:01:41 PM
Subject: Re: NPTL support

You'll have to use the uClibc-nptl branch on their svn. In 0.9.28, no.

//Markus

On 2 Nov 2007, at 06:03, veerasena reddy wrote:

> Hi,
>
> I am trying to build the toolchain for MIPS processor using buildroot.
> I am using gcc version of 3.4.3, binutils-2.15, uclibc-0.9.28 and  
> linux-2.6.18.8 kernel.
>
> Basically i need to enable NPTL feature support in my toolchain.
> does uclibc-0.9.28 has the support for NPTL?
> If not, how can i get it enabled for my above build configuration?
>
> I see there is separate branch "uclibc-nptl" in uclibc.
> Do i need to use this (uclibc-nptl) to meet my requirement?
>
> Could you please suggest me right approach to succssfully enable NPTL?
>
> Thanks in advance.
>
> Regards,
> Veerasena.
>
>
>      Why delete messages? Unlimited storage is just a click away.  
> Go to http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/ 
> tools-08.html
>
>

_______________________________________

Mr Markus Gothe
Software Engineer

Phone: +46 (0)13 21 81 20 (ext. 1046)
Fax: +46 (0)13 21 21 15
Mobile: +46 (0)73 718 72 80
Diskettgatan 11, SE-583 35 Linköping, Sweden
www.27m.com


      Did you know? You can CHAT without downloading messenger. Go to http://in.messenger.yahoo.com/webmessengerpromo.php/ 

