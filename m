Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbZGFHwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbZGFHwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 03:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZGFHwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 03:52:12 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:53080 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZGFHwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 03:52:11 -0400
Date: Mon, 6 Jul 2009 09:16:00 +0200
From: Nico Schottelius <nico-linux-20090706@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: FREEZE with 2.6.31-rc1-next-20090626-02876-g39ddbf4
Message-ID: <20090706071600.GA9488@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090706@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc7 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

I just gave 2.6.31-rc1-next-20090626-02876-g39ddbf4 a try on X200 (amd64); =
The result
is a bit shocking:

It freezes after some minutes running xorg. The image is still fine, no mov=
ements,
no keyboard.

Nico

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpRpLAACgkQuL75KpiFGIxhJACg3lotn5MEAE12pSELTVPjOKyi
cCMAoKyQRBK2h6Pl/qtPuygTjjaVTzAF
=869m
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
