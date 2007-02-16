Return-Path: <linux-kernel-owner+w=401wt.eu-S1422762AbXBPADK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422762AbXBPADK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422767AbXBPADK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:03:10 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50942 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422762AbXBPADI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:03:08 -0500
X-Sasl-enc: DnPMtF0CM5OZNvMzEshxF7lReII4FWOoVKO/QXbGpbZZ 1171584193
Message-ID: <45D4F4EE.7050307@imap.cc>
Date: Fri, 16 Feb 2007 01:03:58 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Hansjoerg Lipp <hjlipp@web.de>, gigaset307x-common@lists.sourceforge.net,
       kkeil@suse.de, kai.germaschewski@gmx.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] correct CONFIG_GIGASET_M101 Makefile entry
References: <20070215215609.GH13958@stusta.de>
In-Reply-To: <20070215215609.GH13958@stusta.de>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFD5E1BB233CFCDCE881768E9"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFD5E1BB233CFCDCE881768E9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 15.02.2007 22:56 schrieb Adrian Bunk:
> Advanced Mathematics, lesson 1:
> 101 !=3D 105

Ouch. Sorry. Thanks for catching that one.

> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: Tilman Schmidt <tilman@imap.cc>

> ---
> --- linux-2.6.20-mm1/drivers/isdn/gigaset/Makefile.old	2007-02-15 17:38=
:23.000000000 +0100
> +++ linux-2.6.20-mm1/drivers/isdn/gigaset/Makefile	2007-02-15 17:38:41.=
000000000 +0100
> @@ -5,4 +5,4 @@
> =20
>  obj-$(CONFIG_GIGASET_M105) +=3D usb_gigaset.o gigaset.o
>  obj-$(CONFIG_GIGASET_BASE) +=3D bas_gigaset.o gigaset.o
> -obj-$(CONFIG_GIGASET_M105) +=3D ser_gigaset.o gigaset.o
> +obj-$(CONFIG_GIGASET_M101) +=3D ser_gigaset.o gigaset.o
>=20


--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigFD5E1BB233CFCDCE881768E9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF1PT5MdB4Whm86/kRAqQWAJ4hUuQBpP73NDJcLSZZY5IFj1fYTwCaAvIC
6jKSxbDlMvmS1m27D8h2SLA=
=g0ZV
-----END PGP SIGNATURE-----

--------------enigFD5E1BB233CFCDCE881768E9--
