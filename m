Return-Path: <linux-kernel-owner+w=401wt.eu-S965193AbXBYW6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965193AbXBYW6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 17:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965195AbXBYW6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 17:58:13 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:44604 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965193AbXBYW6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 17:58:12 -0500
X-Sasl-enc: E1aTUdPww7Ivb/oewQmDNPARSL8NWGmt8d8NXIHWvE1Y 1172444291
Message-ID: <45E214C9.5050709@imap.cc>
Date: Sun, 25 Feb 2007 23:59:21 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: Add the code maturity levels DEPRECATED and OBSOLETE.
References: <Pine.LNX.4.64.0702181203360.5131@CPE00045a9c397f-CM001225dbafb6> <200702181935.07454.bzolnier@gmail.com> <45DB218E.1080106@imap.cc> <200702201942.50186.bzolnier@gmail.com> <Pine.LNX.4.64.0702201750030.11016@localhost.localdomain> <45DB805C.5010808@imap.cc> <20070225104255.GD2045@elf.ucw.cz>
In-Reply-To: <20070225104255.GD2045@elf.ucw.cz>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig840D01E9974B242EFFAA7EF5"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig840D01E9974B242EFFAA7EF5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 25.02.2007 11:42 schrieb Pavel Machek:
> On Wed 2007-02-21 00:12:28, Tilman Schmidt wrote:
>> Am 20.02.2007 23:52 schrieb Robert P. J. Day:
>>> "deprecated" means that there *is* a complete replacement available
>>> *right now* and you should consider switching to it.
>>>
>>> if you can't offer someone a completely functional, better alternativ=
e
>>> to what they're using now, then you can't say that what they're using=

>>> now is deprecated.
>> So, to take a specific example (incidentally the one I am
>> personally interested in):
>>
>> isdn4linux (CONFIG_ISDN_I4L), currently marked as "obsolete"
>> (which is undoubtedly incorrect), would not even qualify as
>> "deprecated" as long as its successor, the CAPI 2.0 subsystem
>> (CONFIG_ISDN_CAPI) doesn't support all the hardware currently
>> supported by old i4l.
>=20
> It probably never will. Some hardware is so obsolete that noone will
> care :-).

s/supported by/in active use with/

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig840D01E9974B242EFFAA7EF5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF4hTRMdB4Whm86/kRAmRxAJ4lUiWTvkFcKYLlodqdbeIm6dmCsgCfVElm
f9MhEXOJ8aD7IQtkel9badI=
=11KI
-----END PGP SIGNATURE-----

--------------enig840D01E9974B242EFFAA7EF5--
