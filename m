Return-Path: <linux-kernel-owner+w=401wt.eu-S1763466AbXIZWhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763466AbXIZWhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbXIZWha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:37:30 -0400
Received: from pc175e.fzu.cz ([147.231.127.175]:56571 "EHLO postak-2.fzu.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXIZWh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:37:29 -0400
Message-ID: <46FADF0C.7000808@gentoo.org>
Date: Thu, 27 Sep 2007 00:37:00 +0200
From: =?UTF-8?B?SmFuIEt1bmRyw6F0?= <jkt@gentoo.org>
Organization: Gentoo
User-Agent: Thunderbird 2.0.0.6 (X11/20070812)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: kswapd high CPU usage with no swap
References: <46F852B6.7030207@gentoo.org>	<20070924223444.62f0622d@bree.surriel.com>	<46F8DF55.2030905@gentoo.org>	<20070925213156.68fceea2@bree.surriel.com>	<46FA09E8.7010101@gentoo.org> <20070926112510.314e8775@cuia.boston.redhat.com>
In-Reply-To: <20070926112510.314e8775@cuia.boston.redhat.com>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig55E83892C02BE5533CE58337"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig55E83892C02BE5533CE58337
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>> When this is sorted out, should I keep the previous patch [1] applied
>> as well?
>=20
> That doesn't hurt.

OK, I've used just the latter patch (because I somehow believe the first
one lowers the probability of bad behavior), so let's see if kswapd
consumes CPU again. I don't have any test patter to trigger that CPU
usage, though...

Cheers and thanks for your time,
-jkt

--=20
cd /local/pub && more beer > /dev/mouth


--------------enig55E83892C02BE5533CE58337
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG+t8RamXfqERyJRcRAul5AJ9Dbh/WfyQwq8PrAe6LZfdfpnjndQCbBctN
WfSmesFREnSzj7QUd2sn5jQ=
=gBOK
-----END PGP SIGNATURE-----

--------------enig55E83892C02BE5533CE58337--
