Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbYJYXKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbYJYXKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 19:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbYJYXDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 19:03:05 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49068 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754630AbYJYXDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 19:03:04 -0400
X-Sasl-enc: UbdRRc0MrG4ES44gP0jQHMTPCuPCbohpIV5K0DdzEEHY 1224975780
Message-ID: <4903A598.7020706@imap.cc>
Date: Sun, 26 Oct 2008 01:02:48 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11833] 2.6.27-git8 compile error in drivers/mfd/wm8350-core.c
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera> <t1C3RWL0r7M.A.rkC.xV5AJB@chimera>
In-Reply-To: <t1C3RWL0r7M.A.rkC.xV5AJB@chimera>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2231BCA7B5E660B151A62462"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2231BCA7B5E660B151A62462
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Rafael J. Wysocki schrieb:
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me kno=
w
> (either way).
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D11833
> Subject		: 2.6.27-git8 compile error in drivers/mfd/wm8350-core.c
> Submitter	: Tilman Schmidt <tilman@imap.cc>
> Date		: 2008-10-19 18:17 (7 days old)
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D122444027920472&w=3D=
4

Fixed in 2.6.28-rc1 by commit c7752351c34d852ca0da697f812534101eecd82e:
mfd: Don't use NO_IRQ in WM8350

Thanks,
Tilman


--------------enig2231BCA7B5E660B151A62462
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFJA6WiQ3+did9BuFsRArJHAJ9tMZ730OzWIFp4y81SZXLOQRnG0gCfXmRQ
7ZHBg3R5D0w0fNc6BKgPWWA=
=2f5c
-----END PGP SIGNATURE-----

--------------enig2231BCA7B5E660B151A62462--
