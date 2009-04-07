Return-Path: <linux-kernel-owner+w=401wt.eu-S1760732AbZDGUiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732AbZDGUiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759041AbZDGUhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:37:52 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:56031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758793AbZDGUhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:37:51 -0400
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239135878.17958.11.camel@maxim-laptop> (sfid-20090407_222443_633750_085B264D)
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)  <1239109001.22453.40.camel@johannes.local>
	 <1239109497.15015.12.camel@maxim-laptop>
	 (sfid-20090407_150534_375314_4DA28551)  <1239110010.22453.41.camel@johannes.local>
	 <1239110412.15015.23.camel@maxim-laptop>
	 (sfid-20090407_152021_060436_AEF9110F)  <1239110860.4084.0.camel@johannes.local>
	 <1239112310.15015.25.camel@maxim-laptop>
	 <1239135878.17958.11.camel@maxim-laptop>
	 (sfid-20090407_222443_633750_085B264D)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rTsNHbRqMDQTm6MFc5Sm"
Date: Tue, 07 Apr 2009 22:37:17 +0200
Message-Id: <1239136637.7475.57.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rTsNHbRqMDQTm6MFc5Sm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 23:24 +0300, Maxim Levitsky wrote:

> First I get this in kernel logs:
>=20
>=20
> > [   29.971903] WARNING:
> at /home/maxim/software/kernel/linux-2.6/net/wireless/core.h:79
> nl80211_send_wiphy+0x8bd/0xa20 [cfg80211]()

Eh, I don't think that is present in a recent wireless tree.

johannes

--=-rTsNHbRqMDQTm6MFc5Sm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ27l6AAoJEKVg1VMiehFYWwQP/i8S5heEHp+qyopOy2DxFtWt
P2cxbgUzy13lyQ8L0zbZQhFUFjkBRIdC1QKwqceMuHDF/9/mc9V6QShPnGhQcp9c
QsitprbskxZJo08dF+IMWOkZGWdPrqMvlOawbY0q+ZH9aSk76Nsufde8SvFrzwc4
ph8MnMsRDnJn06LTTd4J4KMI8HYYGUYdOt3uk9wbk+1IK0kF/vxgnat0+iGirE0S
kQrO/PnWKpaF7wF3Y6crIXcxUDWUtEnkXsV9677sFt6QlVJVYgs79gQRhrfsswY2
VtjRdP3c1BdggqAn3OVtnmSXfzB5oTvOVzNzOS7W9j7DTqm0qQ73rUE8OhIqEdU/
A8EFQguN9TFvp02dyuVj+VcrFzSL5Dbn/rdESGXxGPfZ7fZSedyiwz9oBobNu0BP
DI9NZwJVLBsRTcTE5XI/5YEPMJIqofraAtGgvRBksJqzdJPJcGcUDAPKPv/uBaKV
NYG1huOy+69yud+62zsc4LCcLrMAMaxj7C3q4675iCqA0I9vZ0EoU1o72Mv8Na1i
Dl5hk7D+vKpqEG8i19XzECiJB/X0mFZ/hT2mP3VuI40vC4TNpu8sFNPVoalfDbS2
TvcsZCGVmYa9peIOR8zGzWsirryp10hL2beHdI6FnbALrcYZZ3C2VKmvC1K7DMma
Wp6h71O+hhSLXK4E8Or9
=2JVt
-----END PGP SIGNATURE-----

--=-rTsNHbRqMDQTm6MFc5Sm--

