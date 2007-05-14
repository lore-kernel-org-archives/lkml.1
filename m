Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbXENNAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbXENNAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 09:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXENNAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 09:00:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:51938 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751793AbXENNAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 09:00:41 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX19uv9EITeRuH2VlY+dGCWXCZo6H67Xc3mgrdgrnz/
	C1XTpSb4tfRk1Q
Message-ID: <46485D84.1010902@gmx.de>
Date: Mon, 14 May 2007 15:00:52 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: How to access correctly serial port inside module?
Content-Type: multipart/mixed;
 boundary="------------030404010708050502000302"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------030404010708050502000302
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

hallo,

after searching the mailing list and searching the web, I still don't
know how to access correctly the serial port (in user space known as
/dev/ttyS01)

This thread ends before the answer was given and the site redirecting
too is restructured: http://marc.info/?l=kernelnewbies&m=98314502419089&w=2

would somebody be so kind to give me an example:

with this behaviour:

1. read from port
2. output via printk()
3. write to port

I'm learning how to write modules:

I've created already my own char-dev and used it in user-space.
However I don't know really how to get information from kernel-code to
solve this.

thx in advance

14.05.2007 14:46
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGSF2FAAomYJ1taN8RAnPfAKCdpnT+Uxa8a1Mc85TCyDzNwsvuQQCgzHIx
f7V/XEWtWCa2IWtYjk7W7dg=
=y/NM
-----END PGP SIGNATURE-----

--------------030404010708050502000302
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


--------------030404010708050502000302--

