Return-Path: <linux-kernel-owner+w=401wt.eu-S1030777AbXDUM1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030777AbXDUM1l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 08:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030781AbXDUM1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 08:27:41 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:38517 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030777AbXDUM1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 08:27:40 -0400
X-Sasl-enc: Bi6DIKpvTTdo0lI8PZnGKczv281Sh9iy1WUwgZPr+ANB 1177158459
Message-ID: <462A03D7.4030508@imap.cc>
Date: Sat, 21 Apr 2007 14:30:15 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i4ldeveloper@listserv.isdn4linux.de,
       Andrew Morton <akpm@linux-foundation.org>, Karsten Keil <kkeil@suse.de>
Subject: Re: other potentially deletable, dead stuff
References: <Pine.LNX.4.64.0704201901470.2187@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0704201901470.2187@CPE00045a9c397f-CM001225dbafb6>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE840A26DA2F12A412A92E672"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE840A26DA2F12A412A92E672
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 21.04.2007 01:19 schrieb Robert P. J. Day:
> [...] here's the short list of other stuff that is listed as on
> its way to being dead, based on the contents of Kconfig files.  any of
> this stuff candidates for removal, if not scheduling for removal?

[...]

> config ISDN_I4L
>         tristate "Old ISDN4Linux (obsolete)"

<message type=3Drecorded>

The "obsolete" label on the ISDN_I4L Kconfig option is,
and has always been, incorrect.

isdn4linux is not obsolete.

isdn4linux is in active use, and there is no replacement.

Removing isdn4linux would constitute a serious regression.

</message>

--=20
Tilman Schmidt                                  E-Mail: tilman@imap.cc
Wehrhausweg 66                                  Fax: +49 228 4299019
53227 Bonn
Germany


--------------enigE840A26DA2F12A412A92E672
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGKgPXMdB4Whm86/kRArBuAKCA0fYKtg7/mT1bs5/K84yO9p7yVQCeJbji
1029z55+xxXyov1Vv0SCnnI=
=YKZ1
-----END PGP SIGNATURE-----

--------------enigE840A26DA2F12A412A92E672--
