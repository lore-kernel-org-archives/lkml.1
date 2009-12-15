Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbZLOWqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbZLOWqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760177AbZLOWp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:45:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46376 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755780AbZLOWp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:45:57 -0500
Date: Wed, 16 Dec 2009 09:45:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tony Lindgren <tony@atomide.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org
Subject: Re: linux-next: origin tree build failure
Message-Id: <20091216094541.e59d36fa.sfr@canb.auug.org.au>
In-Reply-To: <20091215172717.GF4575@atomide.com>
References: <20091215164108.45c9d766.sfr@canb.auug.org.au>
	<20091215145344.GA30710@sirena.org.uk>
	<20091215172717.GF4575@atomide.com>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Dec_2009_09_45_41_+1100_hHAWWm4gzG0f6=tT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Dec_2009_09_45_41_+1100_hHAWWm4gzG0f6=tT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Tue, 15 Dec 2009 09:27:17 -0800 Tony Lindgren <tony@atomide.com> wrote:
>
> * Mark Brown <broonie@opensource.wolfsonmicro.com> [091215 06:52]:
> > On Tue, Dec 15, 2009 at 04:41:08PM +1100, Stephen Rothwell wrote:
> >=20
> > > I have applied this patch for today (please check):
> >=20
> > Looks good to me too, fwiw:
> >=20
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>=20
> Good thing we have for-next to catch things like this.

Except if the renaming patch had gone through linux-next (even for one
day) we would have found the problem *before* it was in Linus' tree ...

(/me is a little grumpy :-))

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Dec_2009_09_45_41_+1100_hHAWWm4gzG0f6=tT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksoEZUACgkQjjKRsyhoI8x0BwCfVyM1p3B351+TSzFuRO5C+Tb+
lKsAoIlsaqokRC6k3K2wu5pVo8yyXb0H
=BxQL
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Dec_2009_09_45_41_+1100_hHAWWm4gzG0f6=tT--
