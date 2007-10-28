Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbXJ1Kk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbXJ1Kk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 06:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXJ1KkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 06:40:01 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:45129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbXJ1Kj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 06:39:56 -0400
Subject: Re: [PATCH] mac80211: fix printk() format string
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Joe Jezak <josejx@gentoo.org>, Daniel Drake <dsd@gentoo.org>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <472473D2.8040102@freemail.hu>
References: <472473D2.8040102@freemail.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1ng2CL/zMFsLTiFI0XE8"
Date: Sun, 28 Oct 2007 11:41:16 +0100
Message-Id: <1193568076.3966.17.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1ng2CL/zMFsLTiFI0XE8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> Get rid of the following compiler warning message:
>=20
> net/mac80211/ieee80211_sta.c: In function 'ieee80211_rx_mgmt_assoc_resp':
> net/mac80211/ieee80211_sta.c:1187: warning: format '%d' expects type 'int=
', but argument 7 has type 'long unsigned int'

a different fix is already applied.

johannes

--=-1ng2CL/zMFsLTiFI0XE8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyRnS6Vg1VMiehFYAQJWIRAAqmt6jFVH0pVUnODT7Sk8du1uRUQ8T8CL
2YTQ86HGUE4NoBXm0lpT0f5+V22b1dRmPBWo3TWNCsopHB7xuEJvkxQd+uThalIV
uPcYX8rvxnCnSf8bceEt5deh4gaGzVXpEqt7VPt6nvEhygBADCZEHKuJ4+Jrg9CT
pXT6ZeWL2JdPd/dc5hlQHH5a1BWEKy24tjkHS3rbLvI2QPHw430XEkKt37sHlUpS
xe+uaF6eE3q0al8ecLYz1rLvUMiff8mWrqoStLop4Rop9Vc3qM1UpGuexLaeC2OY
QAz5ck3wpCWCVvB429lq5fXrmpLeJybZ5aBRHlIJ3gZIusSpX94zbUlcUP+y4VzT
DMqfLSDCjzI4wgXXYym9gPGQ/7jZKzZ+Snl3j3+KWY5pNsXq6Xf/uPxYfA4DG4gf
nSCvUUEyY2pKlzaurSFuyWp+atdxi8Mp4PyoRVGfnhB2VIclMmuKjfNjhkQCW+00
s6yO5jbcFYDZwhfgrAZlpNWz1gJLtGGu05fW9TvzcO0gLKiFyyZnHAtGf5ND07K4
BHIVCFN3RQaeKOZLrKdOWO3QAQf4hHZtV+j08G+igbihYmcDhf5dKNFbdP0kOT0V
Si/anoqcuSyQz43DRhNsqWEcDD6+e7ueGFXGI8xnvBAbnKDN3lQUITaJA1bUAMci
fYQkH2qxrec=
=FxBT
-----END PGP SIGNATURE-----

--=-1ng2CL/zMFsLTiFI0XE8--

