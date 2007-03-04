Return-Path: <linux-kernel-owner+w=401wt.eu-S1751400AbXCDLgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbXCDLgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 06:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbXCDLgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 06:36:44 -0500
Received: from mail.satronet.sk ([217.144.16.198]:39223 "EHLO mail.satronet.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXCDLgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 06:36:43 -0500
X-Greylist: delayed 1300 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Mar 2007 06:36:43 EST
From: Michal =?utf-8?q?Van=C4=8Do?= <vanco@satro.sk>
Reply-To: vanco@satro.sk
Organization: Satro, s.r.o.
To: linux-kernel@vger.kernel.org
Subject: 2.6.20 ACPI Error
Date: Sun, 4 Mar 2007 12:15:21 +0100
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10572459.U6ndpk9WLk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703041215.24759.vanco@satro.sk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10572459.U6ndpk9WLk
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I've discovered strange errors while booting my laptop (ASUS A7T) with 2.6.=
20 kernel.=20

ACPI: Core revision 20060707
ACPI Error (psloop-0196): Found unknown opcode FD at AML address ffffc20000=
0161d8 offset 5D44, ignoring [20060707]
ACPI Error (psloop-0196): Found unknown opcode FD at AML address ffffc20000=
01628d offset 5DF9, ignoring [20060707]
ACPI Error (psloop-0196): Found unknown opcode FD at AML address ffffc20000=
0161d8 offset 5D44, ignoring [20060707]
ACPI Error (psloop-0196): Found unknown opcode FD at AML address ffffc20000=
01628d offset 5DF9, ignoring [20060707]

Is this related to buggy BIOS of my laptop?

Another strange think I can see is:

=2E.MP-BIOS bug: 8254 timer not connected to IO-APIC

My machine is AMD Turion 64 X2 based laptop with NVidia chipset. I saw thes=
e error with older kernel too (2.6.19, 2.6.18).

regards,
michal

--nextPart10572459.U6ndpk9WLk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF6qpMAaPIPsiOIRwRAtOtAJ0drRJxJvbJDM8RgVHwJndHvsgTmgCeIH9Y
Xt5qycUQQOE3Q5rRumEkZXs=
=v7gn
-----END PGP SIGNATURE-----

--nextPart10572459.U6ndpk9WLk--
