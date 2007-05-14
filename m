Return-Path: <linux-kernel-owner+w=401wt.eu-S1761235AbXENUZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbXENUZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759664AbXENUZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:25:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:44100 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760897AbXENUZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:25:15 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX18lObYuXAQlzeoW0ZTnmCzAorYVpCJvdQAOjtDR36
	O7e0k93n8CrwyX
Message-ID: <4648C5B5.70408@gmx.de>
Date: Mon, 14 May 2007 22:25:25 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de> <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr>
Content-Type: multipart/mixed;
 boundary="------------050402060301010200010903"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------050402060301010200010903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jan Engelhardt schrieb:
> On May 14 2007 19:40, Lars K.W. Gohlke wrote:
>>> hallo,
>>>
>>> after searching the mailing list and searching the web, I still don't
>>> know how to access correctly the serial port (in user space known as
>>> /dev/ttyS01)
>
> http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad
>
>>> This thread ends before the answer was given and the site redirecting
>>> too is restructured:
>>> http://marc.info/?l=kernelnewbies&m=98314502419089&w=2
>>>
>>> would somebody be so kind to give me an example:
>>>
>>> with this behaviour:
>>>
>>> 1. read from port
>>> 2. output via printk()
>>> 3. write to port
>
> inb/inw/inl, printk, outb/outw/outl.
>
>>> I've created already my own char-dev and used it in user-space.
>>> However I don't know really how to get information from kernel-code to
>>> solve this.
>
> http://lwn.net/Kernel/LDD3/
>
>> would be somebody so polite and give me at least a hint?
>> Where to search concretely, or small template.
>
> It's been 4 hours and 40 minutes, and you already expect an answer?
> I don't remember you having paid anyone...
>
>
> 	Jan


sorry, for my impatience, but I saw the traffic on the list and was
wondering ... .

Nevermind, thx.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGSMW4AAomYJ1taN8RAjgYAKDAspdXlQhsFCaGMkr5Y0NiBH5k/ACeN9Gc
xHGfKF0NaSyuA6hlm5byp0o=
=wUWl
-----END PGP SIGNATURE-----

--------------050402060301010200010903
Content-Type: text/x-vcard; charset=utf-8;
 name="lkwg82.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lkwg82.vcf"

begin:vcard
fn:Lars K.W. Gohlke
n:Gohlke;Lars K.W.
email;internet:lkwg82@gmx.de
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------050402060301010200010903--

