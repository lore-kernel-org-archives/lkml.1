Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbZJ0GnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbZJ0GnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 02:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbZJ0GnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 02:43:03 -0400
Received: from clegg.madduck.net ([193.242.105.96]:43149 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346AbZJ0GnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 02:43:02 -0400
Date: Tue, 27 Oct 2009 07:42:58 +0100
From: martin f krafft <madduck@madduck.net>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: What are these ATA exceptions trying to tell me? [2.6.26]
 System Events]
Message-ID: <20091027064258.GA15260@piper.oerlikon.madduck.net>
Mail-Followup-To: Robert Hancock <hancockrwd@gmail.com>,
	linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20091026082350.GA23992@piper.oerlikon.madduck.net>
 <4AE63E98.6040600@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <4AE63E98.6040600@gmail.com>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux squeeze/sid kernel 2.6.31-rc6-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Robert Hancock <hancockrwd@gmail.com> [2009.10.27.0128 +0100]:
> The "SATA link down" part is really quite abnormal, it seems like the
> drive dropped off the SATA link. Rather suspicious of some kind of
> hardware problem..
>=20
> Are the two sets of disks the same model?

Yes. All four disks are. And there are 4 identical MCP55 SATA ports
too. Either those two disks are broken by chance, or the controller
is broken.

Cheers,

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"a mathematician is a device for turning coffee into theorems."
                                                         -- paul erd=F6s
=20
spamtraps: madduck.bogus@madduck.net

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAkrmlm4ACgkQIgvIgzMMSnWsRQCfUkF9ou6J34GKOh91lnL2nyjS
KSkAoLhZNJxT4D/RiC/38YyT0+7m+QlQ
=xGEp
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
