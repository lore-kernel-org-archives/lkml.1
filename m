Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbXB0PHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbXB0PHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 10:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXB0PHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 10:07:33 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:2066 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbXB0PHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 10:07:32 -0500
Message-ID: <45E44914.4010407@imap.cc>
Date: Tue, 27 Feb 2007 16:07:00 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Kyle McMartin <kyle@parisc-linux.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: resource_size_t printk whinging
References: <20070227041648.GB13669@athena.road.mcmartin.ca> <Pine.LNX.4.62.0702271201330.21803@pademelon.sonytel.be> <20070227131506.GA3545@athena.road.mcmartin.ca>
In-Reply-To: <20070227131506.GA3545@athena.road.mcmartin.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8B1DEB6303FDAF26CCACC6B9"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8B1DEB6303FDAF26CCACC6B9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Kyle McMartin schrieb:
> On Tue, Feb 27, 2007 at 12:02:50PM +0100, Geert Uytterhoeven wrote:
>> But we don't run sparse on every build. We do run gcc (a lot).
>=20
> We probably could, in theory...

Not usefully. I try it occasionally, but there's way too much spewage,
in particular of the "symbol was not declared. Should it be static?"
and "symbol shadows an earlier one" varieties.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig8B1DEB6303FDAF26CCACC6B9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF5EkUMdB4Whm86/kRAoUnAJwOJOrof/eoGgvhbB18F3eqCoX8qwCfTIWm
Cs621ssUhguUmHJVmOb5Bh8=
=v5/W
-----END PGP SIGNATURE-----

--------------enig8B1DEB6303FDAF26CCACC6B9--
