Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab0BMG6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 01:58:22 -0500
Received: from clegg.madduck.net ([193.242.105.96]:47414 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0BMG6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 01:58:21 -0500
X-Greylist: delayed 637 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Feb 2010 01:58:21 EST
Date: Sat, 13 Feb 2010 19:42:47 +1300
From: martin f krafft <madduck@madduck.net>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
Message-ID: <20100213064247.GA19295@lapse.rw.madduck.net>
Mail-Followup-To: Justin Piszcz <jpiszcz@lucidpixels.com>,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux squeeze/sid kernel 2.6.32-1-686 i686
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Justin Piszcz <jpiszcz@lucidpixels.com> [2010.02.12.1200 +1300]:
> I may be converting a host to ext4 and was curious, is 0.90 still the
> only superblock version for mdadm/raid-1 that you can boot from
> without having to create an initrd/etc?
>=20
> Are there any benefits to using a superblock > 0.90 for a raid-1 boot
> volume < 2TB?

FYI: http://bugs.debian.org/492897

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
it may look like i'm just sitting here doing nothing.
but i'm really actively waiting
for all my problems to go away.
=20
spamtraps: madduck.bogus@madduck.net

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAkt2SeAACgkQIgvIgzMMSnVdAgCfYgHkLwo6exYLXgNH9jPgf+hg
h2QAoKZFzpPVcN3QzMTziV0KaLiaYDYM
=eJA3
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
