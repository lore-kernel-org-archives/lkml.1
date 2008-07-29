Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbYG2JW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbYG2JW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYG2JWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:22:49 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:2037 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYG2JWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:22:48 -0400
X-Greylist: delayed 1283 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jul 2008 05:22:48 EDT
Message-ID: <488EDC63.8060700@imap.cc>
Date: Tue, 29 Jul 2008 11:01:23 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCF0C3450B2173C0476746DDA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCF0C3450B2173C0476746DDA
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Commit 782e70c6fc2290a0395850e8e02583b8b62264d8, which went into
2.6.25, broke AVM's closed-source driver for this device:

ID 057c:62ff AVM GmbH WLAN USB v1.1 (cdrom mode)
ID 057c:6201 AVM GmbH WLAN USB v1.1

Is there an open source alternative for that driver, or do systems
with that device have to stay with kernel 2.6.24?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigCF0C3450B2173C0476746DDA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIjtxjQ3+did9BuFsRAmQbAKCARHha9QnfBRZyIGWS6/RxcyEm1gCeI36J
7klEUhRZoYSwJzBVFbn7DIg=
=bDIn
-----END PGP SIGNATURE-----

--------------enigCF0C3450B2173C0476746DDA--
