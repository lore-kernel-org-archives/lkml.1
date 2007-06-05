Return-Path: <linux-kernel-owner+w=401wt.eu-S1763935AbXFEHzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763935AbXFEHzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 03:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762652AbXFEHzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 03:55:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:40189 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763208AbXFEHzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 03:55:20 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX1+ck5IefUCc10FdI4kbtiAZBoUK8Wew1+14kX8/XY
	7KG9yyN9NoNEz2
Message-ID: <466516E7.2040401@gmx.de>
Date: Tue, 05 Jun 2007 09:55:19 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tilman@imap.cc, huang.ying.caritas@gmail.com, jengelh@linux01.gwdg.de
Subject: Re: How to access correctly serial port inside module?
Content-Type: multipart/mixed;
 boundary="------------000901070109080502030508"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------000901070109080502030508
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
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

iD4DBQFGZRboAAomYJ1taN8RAkUQAJdOOvEOqXoiWPKd1cWLCpaksMkjAJ9QxH+w
sEIKnmL2TjPB53E1XkLQng==
=K9hA
-----END PGP SIGNATURE-----

--------------000901070109080502030508
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


--------------000901070109080502030508--

