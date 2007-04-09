Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbXDIMyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbXDIMyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 08:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXDIMyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 08:54:15 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54275 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753150AbXDIMyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 08:54:14 -0400
X-Sasl-enc: 7ZuIe1fkNs+5zFZD+tBvmtWo8ZRqtAmxug7OaQwYSYP+ 1176123253
Message-ID: <461A37F7.80109@imap.cc>
Date: Mon, 09 Apr 2007 14:56:23 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.21-rc5 possible regression: KDE processes die silently [fixed]
References: <4601B3D0.3060600@imap.cc> <460FCDE2.1080503@imap.cc> <20070402225006.GI14134@stusta.de>
In-Reply-To: <20070402225006.GI14134@stusta.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA10756992E86A38B0438332E"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA10756992E86A38B0438332E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 03.04.2007 00:50 schrieb Adrian Bunk:
> We also have one bug kwin ran into that got fixed after -rc5:
>=20
> Subject    : kwin dies silently
> References : http://lkml.org/lkml/2007/2/28/112
> Submitter  : Sid Boyce <g3vbv@blueyonder.co.uk>
>              Boris Mogwitz <boris@macbeth.rhoen.de>
>              Michael Wu <aluminum.tape@gmail.com>
> Caused-By  : Eric W. Biederman <ebiederm@xmission.com>
>              commit 0475ac0845f9295bc5f69af45f58dff2c104c8d1
> Fixed-By   : Eric W. Biederman <ebiederm@xmission.com>
> Commit     : 14e9d5730adfca26452b3a2838a80af6950556f5
> Status     : fixed in -rc6

The machine has been running -rc5-git12, then -rc6 for a total
of four days now, and the problem hasn't reoccurred. Looks like
it was indeed the same bug.

Thanks,
Tilman



--------------enigA10756992E86A38B0438332E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGGjgAMdB4Whm86/kRAmQ+AJ9cdPLPUCUo2iSLsS0Wg0nvKUYvhgCeLPPU
PXgLpKsXu6LTDABM22QHN/c=
=jv+D
-----END PGP SIGNATURE-----

--------------enigA10756992E86A38B0438332E--
