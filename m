Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbXKKTGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbXKKTGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 14:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbXKKTGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 14:06:35 -0500
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:58238 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603AbXKKTGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 14:06:34 -0500
Date: Sun, 11 Nov 2007 20:06:29 +0100
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: 2.6.24-rc1-g74521c28: oops during boot [<ffffffff881c03e4>]
 :power_supply:power_supply_show_property+0x94/0x150
In-reply-to: <200711112019.21853.rjw@sisk.pl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Message-id: <473752B5.4050304@archlinux.org>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enigF52A8B1000F5A8E6856CFC36
X-IronPort-AV: E=Sophos;i="4.21,402,1188770400";
 d="asc'?scan'208";a="20724416"
X-Enigmail-Version: 0.95.1
References: <472C5C2D.9010700@archlinux.org> <4736EE1C.3010500@archlinux.org>
 <473750B2.4060208@archlinux.org> <200711112019.21853.rjw@sisk.pl>
User-Agent: Thunderbird 2.0.0.6 (X11/20071015)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF52A8B1000F5A8E6856CFC36
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Rafael J. Wysocki schrieb:
>> Replying to myself again. Apparently, a fix for this bug was applied t=
o
>> the linux-acpi tree independently of my bug report, see here:
>> http://git.kernel.org/?p=3Dlinux/kernel/git/lenb/linux-acpi-2.6.git;a=3D=
commit;h=3D4c41d3ad6544f1c9aec37c441af04f5d0ad3a731
>=20
> I'm having some problems with accessing git.kernel.org right now.  I'll=
 have a
> look when it works again.

Same problem here, it took me some time until I could view it. I forgot
to mention that the patch actually fixes the bug in my case, I can boot
2.6.24 without oopses now.


--------------enigF52A8B1000F5A8E6856CFC36
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHN1K1Eda5KzHP/VARCFZQAJwL4L2Z/Udr7qHLbPyq7GqZO18oBwCdFU24
eD4qVmATkva/uMNhpNp+mvg=
=D9CO
-----END PGP SIGNATURE-----

--------------enigF52A8B1000F5A8E6856CFC36--
