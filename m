Return-Path: <linux-kernel-owner+w=401wt.eu-S1422811AbXBPAQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422811AbXBPAQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422814AbXBPAQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:16:16 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:32966 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422811AbXBPAQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:16:15 -0500
X-Sasl-enc: p79x5MOt6C2fCURb/K7FxKmYj0dROGHgu+tMs240L98Q 1171584981
Message-ID: <45D4F80F.8040200@imap.cc>
Date: Fri, 16 Feb 2007 01:17:19 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Hansjoerg Lipp <hjlipp@web.de>, gigaset307x-common@lists.sourceforge.net,
       kkeil@suse.de, kai.germaschewski@gmx.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/isdn/gigaset/: build asyncdata.o into the
 gigaset module
References: <20070215215638.GI13958@stusta.de>
In-Reply-To: <20070215215638.GI13958@stusta.de>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig58040A4659B9054AACE83C95"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig58040A4659B9054AACE83C95
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 15.02.2007 22:56 schrieb Adrian Bunk:
> This patch fixes the following compile error:
>=20
> <--  snip  -->
>=20
> ...
>   LD      drivers/isdn/gigaset/built-in.o
> drivers/isdn/gigaset/ser_gigaset.o: In function `gigaset_m10x_send_skb'=
:
> (.text+0xe50): multiple definition of `gigaset_m10x_send_skb'
> drivers/isdn/gigaset/usb_gigaset.o:(.text+0x0): first defined here
> drivers/isdn/gigaset/ser_gigaset.o: In function `gigaset_m10x_input':
> (.text+0x1121): multiple definition of `gigaset_m10x_input'
> drivers/isdn/gigaset/usb_gigaset.o:(.text+0x2d1): first defined here
> make[4]: *** [drivers/isdn/gigaset/built-in.o] Error 1

How did you manage to produce that error? I have never encountered it.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig58040A4659B9054AACE83C95
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF1PgPMdB4Whm86/kRAq/VAJ9sAB7Uh5AAtHER/FITdRTRb6xbnQCeILFa
Q77b58y4j1OuFU9F18NqM80=
=/BxZ
-----END PGP SIGNATURE-----

--------------enig58040A4659B9054AACE83C95--
