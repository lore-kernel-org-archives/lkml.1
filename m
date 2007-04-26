Return-Path: <linux-kernel-owner+w=401wt.eu-S1031268AbXDZPWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031268AbXDZPWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031273AbXDZPWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:22:09 -0400
Received: from [80.68.207.18] ([80.68.207.18]:54187 "EHLO smtp.unbit.it"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031268AbXDZPWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:22:08 -0400
Subject: [ANNOUNCE] UidBind LSM 0.3
From: Roberto De Ioris <roberto@unbit.it>
Reply-To: roberto@unbit.it
To: linux-security-module@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j+bcdRd8aD8JX6Gze/+z"
Organization: UnBit
Date: Thu, 26 Apr 2007 17:22:03 +0200
Message-Id: <1177600924.25490.60.camel@hagrid>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-j+bcdRd8aD8JX6Gze/+z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi all,

this is the new release of UidBind LSM:

http://projects.unbit.it/uidbind/


This new version adds support for gid and a new configfs item named
'all'

Unconfigured port will fallback to 'all' item (if available)

A patch for vanilla 2.6.21 is available on the website

--=20
Roberto De Ioris
http://unbit.it
JID: roberto@jabber.unbit.it
Wii: 2999 4476 3509 0964

--=-j+bcdRd8aD8JX6Gze/+z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Questa =?ISO-8859-1?Q?=E8?= una parte del messaggio
	firmata digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMMObl5tD0kpw00gRArvaAJ9VgXS5qRiC1EVTnI7ojXP20o0USQCeI/qH
e56VmhE7Ftma5KLzryL7M8Y=
=9TrK
-----END PGP SIGNATURE-----

--=-j+bcdRd8aD8JX6Gze/+z--

