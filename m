Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZH3ReM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZH3ReM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 13:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZH3ReL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 13:34:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39047 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753881AbZH3ReK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 13:34:10 -0400
X-Sasl-enc: COoMq1AIvairCePENJF0amIiOxeYu9H+/Oi405/9vm1b 1251653651
Message-ID: <4A9AB806.2020906@imap.cc>
Date: Sun, 30 Aug 2009 19:33:58 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Disabling lock debugging due to kernel taint
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig159CEA18C48DE24CE63FF4BC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig159CEA18C48DE24CE63FF4BC
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

In 2.6.31-rc the kernel has sprouted the message in the subject.
Now I completely understand the motivation behind this. Nobody
wants to spend time on problem reports that ultimately turn out
to be caused by closed-source code. But for a maintainer of a
(GPLed) driver like me who happens to need a proprietary
graphics driver it does cause some inconvenience.

Is there a simple way to get lock debugging even with a
proprietary graphics driver?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig159CEA18C48DE24CE63FF4BC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKmrgQQ3+did9BuFsRAnK6AJ0ay8ygnXi3+FK+s7Gw3KsgtzM+pACfWlR2
PI0d+Vrv3BSclBCheRydBuQ=
=uhTO
-----END PGP SIGNATURE-----

--------------enig159CEA18C48DE24CE63FF4BC--
