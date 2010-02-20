Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab0BTWO5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 17:14:57 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:59909 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab0BTWO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 17:14:56 -0500
Subject: Re: [PATCH 2/2] enhance /sys/class/rfkill/<rfkill>/state interface
From: Johannes Berg <johannes@sipsolutions.net>
To: florian@mickler.org
Cc: linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <1266702045-6062-3-git-send-email-florian@mickler.org>
References: <1266702045-6062-1-git-send-email-florian@mickler.org>
	 <1266702045-6062-3-git-send-email-florian@mickler.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EScdXXVwg85L8KwLg7NV"
Date: Sat, 20 Feb 2010 23:14:48 +0100
Message-ID: <1266704090.10980.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EScdXXVwg85L8KwLg7NV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-20 at 22:40 +0100, florian@mickler.org wrote:
> Introduce a new state-value RFKILL_STATE_SOFT_AND_HARD_BLOCKED
> which is returned only through the sysfs state file.
> The other interfaces are designed so that they don't need this extra
> state.
>=20
> This allows the sysfs to represent all possible states an rfkill
> driver can
> have.
>=20
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
>=20
> After stumbling over this arbitrary limitation of
> sys/class/rfkill/*/state I
> wondered what would hinder this patch?

This is not backward compatible, so can't be done.

johannes

--=-EScdXXVwg85L8KwLg7NV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLgF7PAAoJEODzc/N7+QmaG58P/2i1mGDhDvKiQAVsXkx3ra1s
TXwu55/TWAmDMgbRBAaH46UiT4Yw25dsjGFYsNaOtaSdp5B11lW7Noy//Fym12nc
GepEyy/DPhqX40OJPztnb8ZReP/7qKtmOmbLWv46MuB/0nWCwGBT0Lepr2IV2FJo
Qov64gXx28rjha65XefTCCsJHLAMV4YopNqBv9hYS+70HUU7D/YGWSh9+H+TOyt6
Ia1iGPDM1ikWZbC4pcVH5+Cpp3dAkH9d5mcqlpecpPyeJdGYmXjIdX99REdkBo1f
HzGa/j8lAkCrfPm6R+/mi8Pu5BMeyMl1PC0Zd/iSMiPbpygfdiXKtfp5aeLR6aBb
kNiDRMbpSDuze/Exjk9glY/gkeAM7yPQgCofcBBgRxqot4MvYZckFQ3wYKehBfUd
trg9dnYlf3BB0u08DMezQ+Z6R+ScfGBj31PkWuLn1QkeHbomRVGn/YHbGV83YsGh
Fo6hQfJYqtjfogh8iu+RGGGAwyCrdnTbKwa75xZW7llsdS/441OTuElHaEC3rFsy
6jBrFWKiWVvpXSsyLqfFatafskYX3tUADDnoh+nOA5P8r3xiDeh1DOZ2nKDEgt8s
zMRv8QfeRxIzByDKRhvlDVsmE//HGhy7SZlVEjWhzH/ukqz77ditDq4A1U46fNhx
nDEXNfdmU8cPqRuF8pxa
=gRiD
-----END PGP SIGNATURE-----

--=-EScdXXVwg85L8KwLg7NV--

