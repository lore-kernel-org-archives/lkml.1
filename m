Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbYLPO4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbYLPO4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 09:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYLPO4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 09:56:33 -0500
Received: from postman.teamix.net ([194.150.191.120]:52819 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755268AbYLPO4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 09:56:33 -0500
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: linux-kernel@vger.kernel.org
Subject: physical memory limit of 64-bit linux
Date: Tue, 16 Dec 2008 15:56:19 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2837603.n3q4K9eXDt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812161556.25518.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2837603.n3q4K9eXDt
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Hi!

What is the physical memory limit for 64-bit Linux? I read about 40 bit=20
address bus for AMD Athlon X2 (1 TB) and 48 bit for Barcelona X4 (256 TB).

Is 64-bit linux able to use that amount - provided that one would manage to=
=20
build it into a machine? Or does it have a lower limit?

Looking into the Google crystal ball gives unclear pictures... I tend to=20
assume that Linux would handle it, but I am not sure.

Ciao,
=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart2837603.n3q4K9eXDt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklHwZQACgkQHhDFkwOZrpDg1ACfVkKarZZUazhL+cHFC0t3jfGY
X/0An2jJULW+HwEENnPEjUS6MMSKIsLg
=V2cS
-----END PGP SIGNATURE-----

--nextPart2837603.n3q4K9eXDt--
