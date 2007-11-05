Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbXKEMZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbXKEMZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 07:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbXKEMZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 07:25:06 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:37150 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbXKEMZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 07:25:04 -0500
Message-ID: <472F0B96.4080205@27m.se>
Date: Mon, 05 Nov 2007 13:24:54 +0100
From: Markus Gothe <markus.gothe@27m.se>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: veerasena reddy <veerasena_b@yahoo.co.in>
Cc: uclibc@uclibc.org, linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>, buildroot@uclibc.org
Subject: Re: NPTL support
References: <279675.30374.qm@web8411.mail.in.yahoo.com>
In-Reply-To: <279675.30374.qm@web8411.mail.in.yahoo.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

I don't use neither buildroot nor uClibc-nptl, due to uClibc-nptl is a
(dev-)branch and not a release. It differs quite a lot from the 0.9.29
release.

//Markus

veerasena reddy wrote:
> Hi Markus,
>
> thanks for the information.
>
> i checked out uclibc-nptl (version 0.9.29). is it a stable release?
>  If i want to build toolchain using buildroot with nptl support for
> linux kernel 2.6.18.8, could you please guide us the right version
> of buildroot, binutils, and gcc to be used.
>
> Thanks & Regards, Veerasena.
>
> ----- Original Message ---- From: Markus Gothe
> <markus.gothe@27m.se> To: veerasena reddy
> <veerasena_b@yahoo..co.in> Cc: uclibc@uclibc.org; linux-mips
> <linux-mips@linux-mips.org>; linux-kernel.org
> <linux-kernel@vger.kernel.org>; buildroot@uclibc.org Sent: Friday,
> 2 November, 2007 6:01:41 PM Subject: Re: NPTL support
>
> You'll have to use the uClibc-nptl branch on their svn. In 0.9.28,
> no.
>
> //Markus
>
> On 2 Nov 2007, at 06:03, veerasena reddy wrote:
>
>> Hi,
>>
>> I am trying to build the toolchain for MIPS processor using
>> buildroot. I am using gcc version of 3.4.3, binutils-2.15,
>> uclibc-0.9.28 and linux-2.6.18.8 kernel.
>>
>> Basically i need to enable NPTL feature support in my toolchain.
>> does uclibc-0.9.28 has the support for NPTL? If not, how can i
>> get it enabled for my above build configuration?
>>
>> I see there is separate branch "uclibc-nptl" in uclibc. Do i need
>> to use this (uclibc-nptl) to meet my requirement?
>>
>> Could you please suggest me right approach to succssfully enable
>> NPTL?
>>
>> Thanks in advance.
>>
>> Regards, Veerasena.
>>
>>
>> Why delete messages? Unlimited storage is just a click away. Go
>> to http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/
>> tools-08.html
>>
>>
>
> _______________________________________
>
> Mr Markus Gothe Software Engineer
>
> Phone: +46 (0)13 21 81 20 (ext. 1046) Fax: +46 (0)13 21 21 15
> Mobile: +46 (0)73 718 72 80 Diskettgatan 11, SE-583 35 Linköping,
> Sweden www.27m.com
>
>
> Did you know? You can CHAT without downloading messenger. Go to
> http://in.messenger.yahoo.com/webmessengerpromo.php/
>
>


- --
_______________________________________

Mr Markus Gothe
Software Engineer

Phone: +46 (0)13 21 81 20 (ext. 1046)
Fax: +46 (0)13 21 21 15
Mobile: +46 (0)73 718 72 80
Diskettgatan 11, SE-583 35 Linköping, Sweden
www.27m.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHLwuS6I0XmJx2NrwRCLRDAJ9O5mtOAtncebZ9yTZoZpWQLD7hKwCghfdz
IlaSKs6XX+dD6dqC5YFYbRY=
=/Kz+
-----END PGP SIGNATURE-----

