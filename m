Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYESEDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYESEDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 00:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYESEDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 00:03:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52488 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbYESEDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 00:03:24 -0400
Date: Mon, 19 May 2008 14:03:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: corbet@lwn.net (Jonathan Corbet)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Char dev BKL pushdown v2
Message-Id: <20080519140301.ae7d4de6.sfr@canb.auug.org.au>
In-Reply-To: <19845.1211148908@vena.lwn.net>
References: <19845.1211148908@vena.lwn.net>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__19_May_2008_14_03_01_+1000_2_U9y3rTFA.E72AA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_May_2008_14_03_01_+1000_2_U9y3rTFA.E72AA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jon,

On Sun, 18 May 2008 16:15:08 -0600 corbet@lwn.net (Jonathan Corbet) wrote:
>
> There's a new tree with this stuff:
>=20
> 	git://git.lwn.net/linux-2.6.git bkl-removal
>=20
> Stephen, might it be about time to pull this into linux-next and see
> what explodes?

I have added that to today's build right at the end so that if it
explodes too badly, it will be removed again.

I haven't been following this too closely, so how much of this stuff has
been posted/review/tested?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_May_2008_14_03_01_+1000_2_U9y3rTFA.E72AA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIMPv6TgG2atn1QN8RAht9AJ0VwVIq9eR3/J0iyjvGV5ZqPlUoLQCeN9Tj
Krf9W909k5f44RGHDJu68RQ=
=tLXe
-----END PGP SIGNATURE-----

--Signature=_Mon__19_May_2008_14_03_01_+1000_2_U9y3rTFA.E72AA--
