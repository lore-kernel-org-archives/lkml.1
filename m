Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbXJLHOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbXJLHOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758236AbXJLHOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:14:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51294 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbXJLHOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:14:23 -0400
Message-ID: <470F1E92.7020304@scheler.com>
Date: Fri, 12 Oct 2007 09:13:22 +0200
From: Stefan Scheler <stefan@scheler.com>
User-Agent: Mutt/1.5.11
MIME-Version: 1.0
To: Stefan Scheler <stefan@scheler.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression from 2.6.21 to 2.6.22 and above
References: <fekuk7$kpl$1@sea.gmane.org> <470EAE84.3010704@redhat.com>
In-Reply-To: <470EAE84.3010704@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
 protocol="application/pgp-signature";
 boundary="------------enig242134010F76037F21797DDB"
X-Provags-ID: V01U2FsdGVkX180gzZ1mlxBFNMvs2ZwySFA1rAu0tiZu9+Hnr6
 J1SfVUAMvPRNxglQpCiP3F6A8OclWTpqsfUbcO6jE6R04wR+5I
 Px0AmoGBXZ6JiGzRxKbIAuWvG+1n27l
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig242134010F76037F21797DDB
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

> Try turning off USB autosuspend by adding the kernel option
> "usbcore.autosuspend=3D-1". Or if your USB is modular, add "autosuspend=
=3D-1"
> to the module parameters.

Doesn't help. You also might have a look at the linux-usb-devel list. I
posted a couple of logs there.

--=20
Stefan Scheler


--------------enig242134010F76037F21797DDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQFHDx6V3fA/C3QJzpIRA813AJ0WDl1zUskFp26iDwq4NdHJGhS9pQCg2H2j
pS4QvVUm7ncZq3UAOoIWyTE=
=gJQd
-----END PGP SIGNATURE-----

--------------enig242134010F76037F21797DDB--
