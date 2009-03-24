Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZCXI7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZCXI7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787AbZCXI7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:59:12 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:1503 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbZCXI7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:59:11 -0400
Message-ID: <49C89FC8.9080904@imap.cc>
Date: Tue, 24 Mar 2009 10:54:32 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14 Mnenhy/0.7.6.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: stable@kernel.org, kawk@users.sourceforge.net, hjlipp@web.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.27/28-stable] bas_gigaset: correctly allocate USB
 interrupt transfer buffer
References: <20090323-patch-01.tilman@imap.cc> <20090323.150005.113220590.davem@davemloft.net>
In-Reply-To: <20090323.150005.113220590.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF0F76293D8EDB051E04E63F4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF0F76293D8EDB051E04E63F4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Mar 2009 15:00:05 -0700 (PDT), David Miller wrote:
> From: Tilman Schmidt <tilman@imap.cc>
> Date: Mon, 23 Mar 2009 22:47:06 +0100 (CET)
>=20
>> the following patch backports the Gigaset driver bugfix merged for
>> 2.6.29 as commit 170ebf85160dd128e1c4206cc197cce7d1424705 to both
>> v2.6.27.x and v2.6.28.x. I would appreciate to see it included in
>> your stable series.
>=20
> If you ask me I can and will do it during my networking patch
> -stable submission.

Thanks. Please do so.

Regards,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigF0F76293D8EDB051E04E63F4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJyJ/TQ3+did9BuFsRAuRkAJ0UU27JivQR/wea8k8X5oCFYaCnMQCfSsHY
/blVuLAGB/4H/q5K2MLx5fA=
=wXEu
-----END PGP SIGNATURE-----

--------------enigF0F76293D8EDB051E04E63F4--
