Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbXKCSiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbXKCSiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 14:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbXKCSiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 14:38:01 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:43998 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756186AbXKCSiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 14:38:00 -0400
Date: Sat, 03 Nov 2007 19:37:57 +0100
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: 2.6.24-rc1-g74521c28: oops during boot [<ffffffff881c03e4>]
 :power_supply:power_supply_show_property+0x94/0x150
In-reply-to: <200711031926.01665.rjw@sisk.pl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
       linux-kernel@vger.kernel.org
Message-id: <472CC005.4070609@archlinux.org>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enig09E126E15C62406C737A97A5
X-IronPort-AV: E=Sophos;i="4.21,367,1188770400";
 d="asc'?scan'208";a="32670151"
X-Enigmail-Version: 0.95.1
References: <472C5C2D.9010700@archlinux.org> <200711031926.01665.rjw@sisk.pl>
User-Agent: Thunderbird 2.0.0.6 (X11/20071015)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig09E126E15C62406C737A97A5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Rafael J. Wysocki schrieb:
> On Saturday, 3 November 2007 12:31, Thomas B=E4chler wrote:
>> I am trying to boot 2.6.24-rc1-g74521c28 from the linux-2.6 git tree.
>> During boot, I get a kernel oops when udevtrigger is running, thus mos=
t
>> devices are not created and the boot stalls.
>>
>> Fortunately, the services are still started (though I don't see anythi=
ng
>> due to missing ttys) and syslog caught the oops. The logfile and confi=
g
>> are attached.
>=20
> Can you please attach these files to the bugzilla entry at:
>=20
> http://bugzilla.kernel.org/show_bug.cgi?id=3D9299

Done.


--------------enig09E126E15C62406C737A97A5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHLMAFEda5KzHP/VARCGBwAKCVUcVRsp4epu9rABKdvhqtIvAEMwCfQ0Yy
IQM/D2X4Ke3a95lzz0r6nd8=
=pwV8
-----END PGP SIGNATURE-----

--------------enig09E126E15C62406C737A97A5--
