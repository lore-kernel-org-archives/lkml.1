Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbYFWHjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbYFWHjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 03:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYFWHje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 03:39:34 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:1581 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYFWHjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 03:39:33 -0400
Message-ID: <485F52FF.8060807@imap.cc>
Date: Mon, 23 Jun 2008 09:38:39 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andreas Herrmann <aherrman@arcor.de>
CC: Hansjoerg Lipp <hjlipp@web.de>, gigaset307x-common@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       kkeil@suse.de
Subject: Re: [PATCH] gigaset: fix module reference counting
References: <20080606223918.GA10348@kodscha> <4855A145.90803@imap.cc> <20080623073227.GA6033@obelix>
In-Reply-To: <20080623073227.GA6033@obelix>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7D78B03AF6E81436D02FFC88"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7D78B03AF6E81436D02FFC88
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi,

am Date: Mon, 23 Jun 2008 09:32:27 +0200 schrieb Andreas Herrmann:
> So it seems that I have mixed up different kernel versions when I've
> tested my patch. Because with current git-tree bas_gigaset can be
> unloaded without any problems.
>=20
> Sorry for the noise.

No problem. Thanks for the feedback.

Take care,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig7D78B03AF6E81436D02FFC88
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIX1MHQ3+did9BuFsRAiQGAJ99cNJRiU+95DQbR/Vd46Cnryh2jACgkSer
St7nxq+w2L0Sw97jVl9L9qM=
=7QQ4
-----END PGP SIGNATURE-----

--------------enig7D78B03AF6E81436D02FFC88--
