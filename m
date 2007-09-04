Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbXIDOZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbXIDOZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 10:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbXIDOZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 10:25:27 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:1181 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbXIDOZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 10:25:26 -0400
Message-ID: <46DD6ACE.8050903@imap.cc>
Date: Tue, 04 Sep 2007 16:25:18 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paulo Marques <pmarques@grupopie.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kernel panic with 2.6.23-rc5
References: <46DD6320.9080103@grupopie.com>
In-Reply-To: <46DD6320.9080103@grupopie.com>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB8D30B3BD5747D22A1CA8FF7"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB8D30B3BD5747D22A1CA8FF7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Paulo Marques schrieb:
> I just tried booting a brand new 2.6.23-rc5 and after a few minutes it =

> just panicked: machine totally frozen, blinking keyboard leds.
[...]
> Maybe someone out there has a good suggestion that I could try before=20
> bisecting...

A probable candidate would be:

http://lkml.org/lkml/2007/9/2/219

HTH
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigB8D30B3BD5747D22A1CA8FF7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG3WrOQ3+did9BuFsRAjggAJ4gD9VxqF7R7HDAfxCJ82YGRuV/GwCbBqNv
QxqWxyKT9uh0ZWNmrw61rYk=
=j3Gf
-----END PGP SIGNATURE-----

--------------enigB8D30B3BD5747D22A1CA8FF7--
