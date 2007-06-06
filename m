Return-Path: <linux-kernel-owner+w=401wt.eu-S1763659AbXFFKwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763659AbXFFKwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759916AbXFFKwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:52:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:43363 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755875AbXFFKwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:52:12 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX18XfI4rAV8X+BOWeW9upGbspAzX6r4/PKGSwFgjv+
	k1imYYA1yIsT64
Message-ID: <466691DD.9060904@gmx.de>
Date: Wed, 06 Jun 2007 12:52:13 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: "Lars K.W. Gohlke" <lkwg82@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: serio interface
References: <46667A3B.8070708@gmx.de> <20070606091503.GI2649@lug-owl.de> <46667FB9.70206@gmx.de> <20070606095159.GK2649@lug-owl.de> <46668ED5.5000807@gmx.de> <20070606104426.GL2649@lug-owl.de>
In-Reply-To: <20070606104426.GL2649@lug-owl.de>
Content-Type: multipart/mixed;
 boundary="------------010000060801030305080400"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------010000060801030305080400
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jan-Benedict Glaw schrieb:
> On Wed, 2007-06-06 12:39:17 +0200, Lars K.W. Gohlke <lkwg82@gmx.de> wrote:
>> Jan-Benedict Glaw schrieb:
>>> OTOH, why do you want to do the serial stuff in kernel land? Isn't it
>>> a *lot* easier to do it in userspace? What's your specific device you
>>> want to work on?
>
> [snip]
>
> You didn't actually answer any of my questions.
>
> MfG, JBG
>
sorry.

I want to use the interface aka /dev/ttyS0.
I want to process data inside of a kernel module to provide it /proc
(done) or as own char-dev (done).

but I can not grab the data.

It is part of my project in my studies.

It is more a conceptual work, but important. I want to release a howto,
when I complete.

answered completely? ;) Hope so.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGZpHfAAomYJ1taN8RApsWAJ970RteJmHUsHocvt71lIvNSzk+XQCgxxg1
gxXm4kZRrRgrhIWfHPKTwEo=
=zMd7
-----END PGP SIGNATURE-----

--------------010000060801030305080400
Content-Type: text/x-vcard; charset=utf-8;
 name="lkwg82.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lkwg82.vcf"

YmVnaW46dmNhcmQNCmZuOkxhcnMgSy5XLiBHb2hsa2UNCm46R29obGtlO0xhcnMgSy5XLg0K
ZW1haWw7aW50ZXJuZXQ6bGt3ZzgyQGdteC5kZQ0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnZl
cnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------010000060801030305080400--

