Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbXFCU3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbXFCU3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXFCU25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:28:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:32890 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750719AbXFCU24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:28:56 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX19dK70vnWJdD1SMxF6R997mYxmm+EF4IDSpmLGfYY
	F425x3EmSomZcp
Message-ID: <46632489.9070107@gmx.de>
Date: Sun, 03 Jun 2007 22:28:57 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: huang ying <huang.ying.caritas@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de>	 <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr>	 <4648E9F7.5090908@imap.cc> <851fc09e0705162315w3380ddabh9b9f0b2198cb8457@mail.gmail.com> <465366CB.7090608@imap.cc>
In-Reply-To: <465366CB.7090608@imap.cc>
Content-Type: multipart/mixed;
 boundary="------------080504080705050200090301"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------080504080705050200090301
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Tilman Schmidt schrieb:
> Am 17.05.2007 08:15 schrieb huang ying:
>> I think the "serio" (through drivers/input/serio/serport.c) may be a
>> choice too, like that in linux/drivers/input/mouse/sermouse.c, which
>> is an example to program serial port in kernel space.
>
> Interesting. I wonder if that would have been a better choice for
> the Gigaset M101 driver. It seems even to have a probe mechanism
> so one could try to determine if the expected device is really
> connected to the port.
>
> Is there any documentation on this interface? I find the source a
> bit hard to understand, sparsely commented as it is.
>
> Thanks
> Tilman
>
how can I open ttyS1 with major=4 and minor=65?

Does anybody have some code to read from it the first e.g. 2bytes?

thx
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGYySKAAomYJ1taN8RAsqpAKCEH/SXOwHuXcopa0cIGtpcE+yQeQCePzkg
gkODYbHe8Hwww9EhpE9+dco=
=BPGZ
-----END PGP SIGNATURE-----

--------------080504080705050200090301
Content-Type: text/x-vcard; charset=utf-8;
 name="lkwg82.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lkwg82.vcf"

YmVnaW46dmNhcmQNCmZuOkxhcnMgSy5XLiBHb2hsa2UNCm46R29obGtlO0xhcnMgSy5XLg0K
ZW1haWw7aW50ZXJuZXQ6bGt3ZzgyQGdteC5kZQ0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnZl
cnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------080504080705050200090301--

