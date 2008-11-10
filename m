Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYKJF0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYKJF0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 00:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYKJF0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 00:26:45 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:27798 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbYKJF0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 00:26:44 -0500
Date: Mon, 10 Nov 2008 00:26:35 -0500
From: "Michael B. Trausch" <mike@trausch.us>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Bug #11942] AMD64 reboot regression
Message-ID: <20081110002635.0230df7c@zest>
In-Reply-To: <fa.38bTHpsfCYAW4EntXFGUmhsiGuM@ifi.uio.no>
References: <fa.2DQVKHtKWLXQ2p0dctmcfapVlZ4@ifi.uio.no>
	<fa.38bTHpsfCYAW4EntXFGUmhsiGuM@ifi.uio.no>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
X-Face: V.VYf~Py*A]A=Ig&q'ryc:4rZ;J![}&08<H1=7E_.O\dF8Pbw,VE~_9QSzcs]DSM%TGA4j\
 .0/Sz8G(4s<D2VQ/uwq$dEL]LbY/y5TYyD$/6It5Yv#c=zo>wpW.<5dFb>I:aB^uO~EL+FT]m5[I4H
 s,s=
X-Operating-System: Ubuntu 8.10 (Intrepid Ibex)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/r+Sa1IQfyjuLetUuUD4D2/Z";
 protocol="application/pgp-signature"; micalg=PGP-RIPEMD160
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/r+Sa1IQfyjuLetUuUD4D2/Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 09 Nov 2008 20:01:31 UTC
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me
> know (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D11942
> Subject	: AMD64 reboot regression

This one is still present in -rc4.

Any idea if the fix will make it in before release?

	Thanks,
	Mike

--=20
My sigfile ran away and is on hiatus.
http://www.trausch.us/

--Sig_/r+Sa1IQfyjuLetUuUD4D2/Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREDAAYFAkkXxgsACgkQ0kE/IBnFmjBF+QCeNi8tpFZWuI0w6OztaT5aLRen
sukAn2nXh3UcqNPV2CAM4SBKJXkymgEO
=/8Hx
-----END PGP SIGNATURE-----

--Sig_/r+Sa1IQfyjuLetUuUD4D2/Z--
