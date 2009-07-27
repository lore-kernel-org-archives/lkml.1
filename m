Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbZG0Iem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbZG0Iem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 04:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZG0Iel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 04:34:41 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:37161 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbZG0Iel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 04:34:41 -0400
Subject: Re: [Bug #13845] inotify regression, missing events
From: Scott James Remnant <scott@ubuntu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>
In-Reply-To: <3zAHs5O6maO.A.ATB.-GObKB@chimera>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
	 <3zAHs5O6maO.A.ATB.-GObKB@chimera>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3QoItgCS3OhMHnb9hCCJ"
Date: Mon, 27 Jul 2009 09:35:38 +0100
Message-Id: <1248683738.22308.0.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3QoItgCS3OhMHnb9hCCJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-07-26 at 22:28 +0200, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13845
> Subject		: inotify regression, missing events
> Submitter	: Scott James Remnant <scott@ubuntu.com>
> Date		: 2009-07-11 16:02 (16 days old)
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D124732816314881&w=3D4
> Handled-By	: Eric Paris <eparis@redhat.com>
>=20
This patch hasn't found its way into Linus' tree yet, so it's definitely
still an issue and should be listed.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-3QoItgCS3OhMHnb9hCCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkptZtoACgkQSnQiFMl4yK7VRACeOWhEpCMCYekOHXRUuOOrlGqz
39oAoIzavCtN3EzNcaqZIm6RdBAFz6lv
=gq2P
-----END PGP SIGNATURE-----

--=-3QoItgCS3OhMHnb9hCCJ--

