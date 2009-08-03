Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbZHCSVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbZHCSVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZHCSVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:21:03 -0400
Received: from mailout07.t-online.de ([194.25.134.83]:54595 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbZHCSVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:21:02 -0400
X-Greylist: delayed 2237 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Aug 2009 14:21:01 EDT
Message-ID: <4A7721B3.3060300@t-online.de>
Date: Mon, 03 Aug 2009 19:43:15 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090623)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Mahoney <jeffm@suse.com>
Subject: Re: [Bug #13374] reiserfs blocked for more than 120secs
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>	 <7ixSg7D88bK.A.guG.mrgdKB@chimera> <c62985530908021801r2e302dfel86f69f62143cabc0@mail.gmail.com>
In-Reply-To: <c62985530908021801r2e302dfel86f69f62143cabc0@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig60B127A1A9B5027D02397445"
X-ID: VTo92aZA8heUFWWrExPFnhVHHCdqJfPgwk+3se-K2v4SQikaWNdb0JXm84Dwm7lg1w
X-TOI-MSGID: d0974702-8bda-4772-a4c4-10467fedebcf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig60B127A1A9B5027D02397445
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Fr=E9d=E9ric Weisbecker wrote:
> Harald,
>=20
> Does it still happen with 2.6.31-rc5 ?
>=20

Using 2.6.30.x kernels (x>=3D0) I haven't seen this problem anymore.
If it is still in, then it seems to be very hard to reproduce.

As suggested I am moving to 2.6.31-rc5. I will mail immediately if
the problem comes back.


Regards

Harri



--------------enig60B127A1A9B5027D02397445
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkp3IbgACgkQUTlbRTxpHjemEQCbBLiH7fQiOz+DhP2kBLNlBLwX
GRgAmQHrFQ/qCkBYaxSLYaK6ecPKGopW
=RpkA
-----END PGP SIGNATURE-----

--------------enig60B127A1A9B5027D02397445--
