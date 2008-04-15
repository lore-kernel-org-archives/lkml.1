Return-Path: <linux-kernel-owner+w=401wt.eu-S1760555AbYDOXdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555AbYDOXdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 19:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYDOXd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 19:33:26 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57105 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487AbYDOXdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 19:33:25 -0400
X-Sasl-enc: zy7j+WIdTtuYRFA2Q+MzB7ZopqUHPaBcZhM5eIfguUPs 1208302404
Message-ID: <48053B41.7050800@imap.cc>
Date: Wed, 16 Apr 2008 01:33:21 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: Re: 2.6.25-rc8-mm1: Intel SATA boot failure
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>	<47F56363.4090002@imap.cc> <20080403161733.c05dac53.akpm@linux-foundation.org> <4802A538.9040107@imap.cc>
In-Reply-To: <4802A538.9040107@imap.cc>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7D02A7091DA2847EDD4C05B9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7D02A7091DA2847EDD4C05B9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 14.04.2008 02:28 schrieb Tilman Schmidt:
> - That leaves only the messages
>=20
>   ata1: port is slow to respond, please be patient (Status 0x80)
>   ata1: COMRESET failed (errno=3D-16)
>=20
>   and accompanying delays during boot, for each installed SATA disk.
>   I'll try to find the time to retest this with 2.6.25-rc8-mm2.

Done. The messages and delays do *not* happen with 2.6.25-rc8-mm2.

HTH
Tilman



--------------enig7D02A7091DA2847EDD4C05B9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIBTtBMdB4Whm86/kRAinJAJsFhl9608wQ54LXCWZQ2QGnGaaWQgCcCNfC
eoaBhNqKDK8hwMUKJEfeTPs=
=uEON
-----END PGP SIGNATURE-----

--------------enig7D02A7091DA2847EDD4C05B9--
