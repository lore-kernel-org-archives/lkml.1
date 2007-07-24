Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbXGXWTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbXGXWTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 18:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756992AbXGXWTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 18:19:04 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52410 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756890AbXGXWTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 18:19:00 -0400
X-Sasl-enc: jZmyGlKiGrOlO/5XoJ8ncFRM2Zyf9rxCQujC3o8d6i1C 1185315539
Message-ID: <46A67AD1.3010202@imap.cc>
Date: Wed, 25 Jul 2007 00:18:57 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [2/2] 2.6.23-rc1: known regressions
References: <46A477AF.4000309@googlemail.com> <46A47936.1090606@googlemail.com>
In-Reply-To: <46A47936.1090606@googlemail.com>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig854EE402FA482FB36BAA2D93"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig854EE402FA482FB36BAA2D93
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable

Am 23.07.2007 11:47 schrieb Michal Piotrowski:

> Virtualization
>=20
> Subject         : 2.6.22-git17 boot failure (XEN)
> References      : http://lkml.org/lkml/2007/7/22/266
> Last known good : ?
> Submitter       : Tilman Schmidt <tilman@imap.cc>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown

"Not a regression."

With the help of Jeremy Fitzhardinge, Andi Kleen and Olaf Hering,
I was able to isolate the cause. It lies outside the kernel, in
the distribution's init script. So the entry can be dropped.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig854EE402FA482FB36BAA2D93
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGpnrRMdB4Whm86/kRAvZVAJ9GT/31HfIh2A5MjZSZyndpv5ghEQCfeD9d
S5EL30pzLAvs1hg4Va3vvKM=
=gXLs
-----END PGP SIGNATURE-----

--------------enig854EE402FA482FB36BAA2D93--
