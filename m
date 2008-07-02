Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYGBXmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYGBXmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 19:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYGBXm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 19:42:29 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:46636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbYGBXm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 19:42:28 -0400
Subject: Re: b43 locks the machine when resuming after suspend to disk
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, debian-kernel@lists.debian.org,
       Giacomo Mulas <gmulas@ca.astro.it>,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <486C0ED0.3080608@lwfinger.net>
References: <alpine.DEB.1.10.0807021830300.32045@capitanata.ca.astro.it>
	 <200807022340.31894.rjw@sisk.pl>	<1215039419.13270.18.camel@johannes.berg>
	 <200807030108.37614.rjw@sisk.pl> <1215040064.13270.20.camel@johannes.berg>
	 <486C0ED0.3080608@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NIMqShNUwNVlYBQ7HWNa"
Date: Thu, 03 Jul 2008 01:41:34 +0200
Message-Id: <1215042094.13270.26.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NIMqShNUwNVlYBQ7HWNa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-02 at 18:27 -0500, Larry Finger wrote:
> Johannes Berg wrote:
> > On Thu, 2008-07-03 at 01:08 +0200, Rafael J. Wysocki wrote:
> >> On Thursday, 3 of July 2008, Johannes Berg wrote:
> >>> Rafael, you misled me :) This is a completely different thing.
> >> Ah, sorry then.  I was too quick with my response.
> >=20
> > No trouble, it reminded me that I wanted to ask stable to pick up that
> > patch anyway although I don't think we ever ran into the issue there.
> >=20
> > This seems very odd though, Giacomo, are you sure it also happens if yo=
u
> > unload the module?
>=20
> I'm confused. Should the "mac80211: detect driver tx bugs" patch be sent =
to stable?

Yeah I think it still should even if that's not the bug here.

johannes

--=-NIMqShNUwNVlYBQ7HWNa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIbBIpAAoJEKVg1VMiehFYOlsP/iwwtM8DHc4i6hoJcS13Whst
8VGa2rbpYzPVNrfK7SSHJyV5nD2RXCMHJDQLc0t45f21F71U8/UnPIKxX/uMf8IF
dH07Gd3D/uGaKSMwCabK2JKspOidqlF0mVaSUixa4vk8FGj3QYKMuz/idxenQn9V
ZQ4ilVm5qkIgF+Biy42uP5kHWPRHgEK0Ck3XGlITuf6PTlZpbNFZZwcWl8MsALee
L7mVoWVnoxyfhU1p6+gNySm6ZpwABwvGqgMPj5HRXwEJ87f1Gb13FerbMdMjsQa1
vcu1pota3zhtMWYnyi/bcvGdBXWH80ZD+sFRmoNZ1OmxJtoSDWulPjwF8PkmnGMs
m67B8g7sZUW3bFGsN629/TtmcpkZJ+DZ7vE5Cata3QI1qXvpL3SB/V9M78tPqjB/
CBvSjP2d7bErnvs8e4aKCfXP+kUIi4TYpL8LMQQ+KUb9oSGsniUxz8/9xtDSDQ4e
6u7xxU6yRJY6YK3VJMBgjYGdsM9ODJ9qdQske8ILuD7+0eWPRVnkxEUvk8hVFHHO
pop9v3Ysl2awwD2EO1Pfof9/qv8c1c+EbRXqJdLWItBJ0w8Y6Mb5tgrOpDyJwJIr
i/wVftQcny5Ht7HCnov2L+If44rJ7dyspKo0cjri7GBs/ukjPRgivYaGrkqynuYd
rN1vDIbBQERjrgtuzIWd
=Oice
-----END PGP SIGNATURE-----

--=-NIMqShNUwNVlYBQ7HWNa--

