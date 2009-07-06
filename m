Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbZGFHru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbZGFHru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 03:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZGFHrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 03:47:43 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:34287 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbZGFHrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 03:47:43 -0400
Date: Mon, 6 Jul 2009 09:47:46 +0200
From: Nico Schottelius <nico-linux-20090706@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Brightness broken: linux-2.6
	7c5371c403abb29f01bc6cff6c5096abdf2dc524
Message-ID: <20090706074746.GB9488@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090706@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc7 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

I tested some 2.6.31-rc1-* versions from git and also realised that sometim=
es
the brightness is broken in 2.6.30-rc7, too.

Running Lenovo X200 (Intel GM45), X.Org X Server 1.4.2
=2E

Sincerly,

Nico

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpRrCIACgkQuL75KpiFGIyu2wCgwoHSl1wI8X3mcrLMLmSSrzlf
OMUAoMBsV35+RCzM1JFvtAZpnXoGlJ93
=K9Yn
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
