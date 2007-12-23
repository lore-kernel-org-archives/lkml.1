Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbXLWUFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbXLWUFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 15:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbXLWUFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 15:05:25 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:41152 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbXLWUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 15:05:24 -0500
Subject: Re: Boot time module loading problem
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>, bcm43xx-dev@lists.berlios.de
In-Reply-To: <476EB966.1020304@lwfinger.net> (sfid-20071223_194013_768138_E3188416)
References: <476D38F9.4090802@gmail.com> <476D567D.3020401@lwfinger.net>
	 <476DE108.6030306@gmail.com> <476DFC95.9010904@lwfinger.net>
	 <476E2A19.1080205@gmail.com>
	 (sfid-20071223_092840_824491_0691F36B) <1198402827.4058.0.camel@johannes.berg>
	 (sfid-20071223_094140_414357_81B4D191) <1198404567.4058.2.camel@johannes.berg>
	 <476E3D6D.1010203@gmail.com>  <476EB966.1020304@lwfinger.net>
	 (sfid-20071223_194013_768138_E3188416)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wk0lD7IiJEIJZOjRYUYe"
Date: Sun, 23 Dec 2007 21:05:12 +0100
Message-Id: <1198440312.4487.3.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wk0lD7IiJEIJZOjRYUYe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> What could be causing such a problem?

I would guess that user has "ssb" loaded from his initrd for some reason
and upgraded the modules by hand.

johannes

--=-wk0lD7IiJEIJZOjRYUYe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR26/d6Vg1VMiehFYAQKm7Q/+KYSEtyBLYh6m29uaoSffAvem93QwPDyg
jhxYk2NTnR3hvXucZrV+6fkvEt1AIsS5YC0Qgq+jeOk/OUj6BggXz0tuUCoyfvXB
o5pfXHd2wmBO7fgSnf7iWtl42ijZWTUCEbVLJw2msqqf0tmStbBGnZmiyQ5qYp7m
BtgLtu2maJa/mpnLga4g4MXRUtc68+LjFEBfAW+MV3Izbu+xgHIffMgJar88/+gb
iuw1eWHenEQ3dQKHdz26eMUvsOrdygH03AXUHQ700gFQ02sOt6DYL4I4drDAFmw8
oVt0IunzaYD20il32bBym8L72U3LDERjVNj4TMDQOvTlfeJ1Rnvo4q7cB9Yc2MIf
XDMtXTwTvBzQb7sVHSiYXSIiJhs7VNY1ErigfsJTO+dlzgQnhy3eAZi0eIraCtlN
V9wpN4KoCu9PW8/TnF6Av8cv/zGwHAPKSZWcJYf8P+ehu/PN3cmTkDFyUXCXy9wk
TcNAlPIJdFTO0+gqyZPiyS9wPNVxb95acHIfgkGcA8nVKbO67q+miN7o7lsaaVUA
trnrOdXNQv/gxkFz15tDIdgv/MaG7u23N0H5kzw8wxuaaVnhSQ14GJN0V3vNATtf
CsMsYuTBhWBPHoTkaQnmv1AgeliYYTm9B6cO3izju/8qVn+rY4AUUYLYWkfpi8ua
yn2wdwlGles=
=J1gj
-----END PGP SIGNATURE-----

--=-wk0lD7IiJEIJZOjRYUYe--

