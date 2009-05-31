Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbZEaKBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbZEaKBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 06:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbZEaKBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 06:01:42 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbZEaKBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 06:01:41 -0400
Subject: Re: [Bug #13362] [mac80211 ] Wifi Network Slownes Bisected
From: Johannes Berg <johannes@sipsolutions.net>
To: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20090531003941.4891c859@varda>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
	 <LEcEO2518_I.A.9zD.8IbIKB@chimera>  <20090531003941.4891c859@varda>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-G4caAvjRFPzFIJE3Wduf"
Date: Sun, 31 May 2009 12:01:36 +0200
Message-Id: <1243764096.19302.34.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-G4caAvjRFPzFIJE3Wduf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-05-31 at 00:39 +0200, Alejandro Riveira Fern=C3=A1ndez wrote:
> El Sat, 30 May 2009 21:37:34 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> escribi=C3=B3:
>=20
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >=20
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me kno=
w
> > (either way).
>=20
>  It should be listed.

But it should definitely be retitled -- the commit bisect pointed out
has little to do with the problem. And Handled-by should point to Ivo
since he was asking for debugging info and stuff.

Retitle to "rt2x00: slow wifi with correct basic rate bitmap" or
something like that, it's not a bug in mac80211.

johannes

--=-G4caAvjRFPzFIJE3Wduf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKIlV9AAoJEODzc/N7+QmaBIMP/1/iACeBzugY8xEqsqyC/Nn3
xNnUZCAhhgozkW9hMQUW3vPG9vgx8AV8BlM6rBbUvOf4V3XzIUY5LM1kc5MXC8ox
0SV7OX3jVUGPt6EvQd8YSNbC7/6MeiHPER0AZA/37gEPkCa57GOejPvAlo6TYDsI
lM81bAHX8c2O73rFbhLuTjCWNtaNHNKqT29rEkTcb+pgc56e6MI1m1bS/mb2tekj
0Wz9dgx8YmjrT+2QwUM56XZwaKVIC3B/03r9o12BYdaJukLMX2AEFwIjGg46+mSt
qvZ4Nx3r2x8tFT95gUnYqr3VdxnpoDIIvDHJSVJD1NQiYYjl5zvg5vK6rABtT5Vo
GfLKqWLAyOdGbXZRSHPZEHWkCefD3M9JVMvOxCXMNlESVUaBYAhQojYNkWWkscNa
fatSBfNQ2k0aqt3nRQHyIPK23UT3aiBpwZX3b9RhO5mr2WMRNxkkSvVHMe/RM799
RMHvaOM2rF8KSDYbDPT7GgAOEC4hSf7fbB1o0Zy02ykSgp9MJbtg8WAhlkLMl/da
lGKVCvbVJE2ijUdxmulw+WXEefopPuwrgP4OIY2ZVhpF8QWQgUQvMVrwZlFwgt1U
pvtLYZW9iq2lTeXamAxovycl1COL9KEKSY+6Xy5jDr3uBJncBJ7T0quweVA4so9W
QVVZajruaRXr+Azxnl0v
=xv/r
-----END PGP SIGNATURE-----

--=-G4caAvjRFPzFIJE3Wduf--

