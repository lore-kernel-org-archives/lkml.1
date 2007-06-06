Return-Path: <linux-kernel-owner+w=401wt.eu-S1761424AbXFFJfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424AbXFFJfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760296AbXFFJev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:34:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:56999 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760700AbXFFJeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:34:50 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX1+hI4IxQtihj6rc4RBzL170Op9RWDfyu1owQUV6fJ
	VLuL9g6R7XyHcZ
Message-ID: <46667FB9.70206@gmx.de>
Date: Wed, 06 Jun 2007 11:34:49 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: "Lars K.W. Gohlke" <lkwg82@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: serio interface
References: <46667A3B.8070708@gmx.de> <20070606091503.GI2649@lug-owl.de>
In-Reply-To: <20070606091503.GI2649@lug-owl.de>
Content-Type: multipart/mixed;
 boundary="------------080203090402050307000106"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------080203090402050307000106
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jan-Benedict Glaw schrieb:
> On Wed, 2007-06-06 11:11:23 +0200, Lars K.W. Gohlke <lkwg82@gmx.de> wrote:
>> wouldsomebody explain me the serio interface or give me a code link for
>> very simple example.
>
> What do you want to do with it?  Do you want on the serial port side,
> or on the mouse/keyboard/gadget side?  See for example the various
> serial keyboards and mice drivers.
>
> MfG, JBG
>
I want on the kernelside process data from first uart-hardware interface
aka ttyS0.

I don't understand the structure of e.g. input/mouse/sermouse.c

where is said, which hardware is used for reading data from?

mfg
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGZn+7AAomYJ1taN8RAlwOAJ4qP5DnhIE7IJ5pCqDGBD4di4zybACgqBq6
8lSB3Zp7qO/bwCK+WsWL+HU=
=3Fdg
-----END PGP SIGNATURE-----

--------------080203090402050307000106
Content-Type: text/x-vcard; charset=utf-8;
 name="lkwg82.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lkwg82.vcf"

YmVnaW46dmNhcmQNCmZuOkxhcnMgSy5XLiBHb2hsa2UNCm46R29obGtlO0xhcnMgSy5XLg0K
ZW1haWw7aW50ZXJuZXQ6bGt3ZzgyQGdteC5kZQ0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnZl
cnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------080203090402050307000106--

