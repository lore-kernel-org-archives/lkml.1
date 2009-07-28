Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZG1Vdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZG1Vdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbZG1Vdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:33:49 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbZG1Vds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:33:48 -0400
Subject: Re: [PATCH] MAINTAINERS: Add networking wireless drivers section
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, linville@tuxdriver.com, julia@diku.dk,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20090728.113353.08715297.davem@davemloft.net>
References: <Pine.LNX.4.64.0907281753540.28189@ask.diku.dk>
	 <20090728.103044.179053537.davem@davemloft.net>
	 <1248804397.18284.5.camel@Joe-Laptop.home>
	 <20090728.113353.08715297.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-36Y6D/GMx/1GBn9tpdRy"
Date: Tue, 28 Jul 2009 23:33:11 +0200
Message-Id: <1248816791.13742.4.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-36Y6D/GMx/1GBn9tpdRy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-28 at 11:33 -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Tue, 28 Jul 2009 11:06:37 -0700
>=20
> > On Tue, 2009-07-28 at 10:30 -0700, David Miller wrote:
> >> Wireless patches need to be CC:'d to linux-wireless so that
> >> John Linville can notice and pick them up
> >=20
> > Signed-off-by: Joe Perches <joe@perches.com>
>=20
> Why not just create a plain "WIRELESS" umbrella entry
> that contains all of drivers/net/wireless, net/mac80211,
> and net/wireless?

I'll happily maintain net/mac80211 and net/wireless, but won't be
touching all the old crappy drivers/net/wireless with a long stick.

johannes

--=-36Y6D/GMx/1GBn9tpdRy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKb26UAAoJEODzc/N7+QmaQ1cP/iQntsvWvy5OYfQpKAbiXtRs
5qEk1Mc7DPM9Mf/oj/WiMMPFLdGvThGyqT95wGmEjioE1BXX58RH2L8x306eqy7K
th2mRFqjPQldf3dV9W8vQRGQaNzizbRYbKG0VFVyKrpJFXG6PCAckMqVio1oGLO6
gs1aX7JGaG2RQC0Cqg0sJsKeiM3emsj0/7lf/uzj0gvYy/xEaJECVMMs93OuxLer
XPOA2vJcD9uT5F31Yr3eJw9h9jQfFJ48dw5L31W3Kz5RtwPw29pNK2gXo8s6MEVw
Iu9r/DdFFoxZ5QdC43sO2tIRwl3rDQ4NP1X0BFZS45dx+eFqt+BuskfbySB7z28N
Pc+k382V/7py1kMENVf4utx0JkXKCmzw2rlF6rCHEkSFkXD7RXtqtQ9ZFtg+URJ5
LIEDhz3UPjRSHCLORYhaeDX1Cr0mIzfUWUI9iFjYGW+bwsO4oES1qhTSs4mGWLbP
RMoe3hNa4o18VZ4TzImBcygTICPWq2Xav7VvA75kmafrBS4ZqIE/JiroNudYo21n
v6BhO7Mj57b7Cn2crW0pV8HhTRJMIVt1pRt7xYRrS+nBVG6qZKju4OajVJESVoLZ
P2zbQwS2JZ9rSbzCTnTG+0ZxHmN8iRec2oEigp1DY5jmGySbyNLrFsOQWrYbnlcs
N8CNpWxwxJUd9KYupcrI
=Qo8W
-----END PGP SIGNATURE-----

--=-36Y6D/GMx/1GBn9tpdRy--

