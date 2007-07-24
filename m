Return-Path: <linux-kernel-owner+w=401wt.eu-S935757AbXGXJjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935757AbXGXJjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934938AbXGXJja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:39:30 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:1471 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935327AbXGXJj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:39:29 -0400
Message-ID: <46A5C8B0.5060401@imap.cc>
Date: Tue, 24 Jul 2007 11:38:56 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Jesper Juhl <jesper.juhl@gmail.com>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	 <200707102015.44004.kernel@kolivas.org>	 <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	 <46A57068.3070701@yahoo.com.au>	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>	 <20070723221846.d2744f42.akpm@linux-foundation.org> <2c0942db0707232301o5ab428bdrd1bc831cacf806c@mail.gmail.com>
In-Reply-To: <2c0942db0707232301o5ab428bdrd1bc831cacf806c@mail.gmail.com>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7D20BFFEDF91EB3B221A9A96"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7D20BFFEDF91EB3B221A9A96
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ray Lee schrieb:
> I spend a lot of time each day watching my computer fault my
> workingset back in when I switch contexts. I'd rather I didn't have to
> do that. Unfortunately, that's a pretty subjective problem report. For
> whatever it's worth, we have pretty subjective solution reports
> pointing to swap prefetch as providing a fix for them.

Add me.

> My concern is that a subjective problem report may not be good enough.

That's my impression too, seeing the insistence on numbers.

> So, what do I measure to make this an objective problem report?

That seems to be the crux of the matter: how to measure subjective
usability issues (aka user experience) when simple reports along the
lines of "A is much better than B for everyday work" are not enough.
The same problem already impaired the "fair scheduler" discussion.
It would really help to have a clear direction there.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enig7D20BFFEDF91EB3B221A9A96
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGpciwMdB4Whm86/kRApXjAJ9DH12VDcvttfRPtDCRrEDs0emn+wCfZgl1
pEWhTqYquIM2Hb/O7HE1gnY=
=yI2D
-----END PGP SIGNATURE-----

--------------enig7D20BFFEDF91EB3B221A9A96--
