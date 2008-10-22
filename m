Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYJVJyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYJVJyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYJVJyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:54:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48175 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbYJVJye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:54:34 -0400
Date: Wed, 22 Oct 2008 20:54:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       ppc-dev <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mfd/wm8350: don't export static functions
Message-Id: <20081022205424.7163e6ec.sfr@canb.auug.org.au>
In-Reply-To: <20081022093721.GA10499@rakim.wolfsonmicro.main>
References: <20081016204754.a41646e5.sfr@canb.auug.org.au>
	<20081016120416.GA5753@rakim.wolfsonmicro.main>
	<20081022203112.5a213e8c.sfr@canb.auug.org.au>
	<20081022093721.GA10499@rakim.wolfsonmicro.main>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__22_Oct_2008_20_54_24_+1100_XqF9jGtAW/1ZVANS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Oct_2008_20_54_24_+1100_XqF9jGtAW/1ZVANS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Wed, 22 Oct 2008 10:37:22 +0100 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> On Wed, Oct 22, 2008 at 08:31:12PM +1100, Stephen Rothwell wrote:
>=20
> > I thought that this had been applied, but I have had to apply it to my
> > tree today again.
>=20
> Samuel doesn't seem to have picked it up (though looking at the CC list
> you've not sent it to him).  I'm going to push another batch of stuff to
> him later today, hopefully he will pick it up then.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__22_Oct_2008_20_54_24_+1100_XqF9jGtAW/1ZVANS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj++FAACgkQjjKRsyhoI8zkMACeOzMeKulLpoaF0yQ+Zcq4JB8o
wSQAniHf/kLZ8yyOnahwVeKSRClcAqJT
=Q8bw
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Oct_2008_20_54_24_+1100_XqF9jGtAW/1ZVANS--
