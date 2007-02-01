Return-Path: <linux-kernel-owner+w=401wt.eu-S1161253AbXBAHYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161253AbXBAHYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 02:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161249AbXBAHYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 02:24:36 -0500
Received: from smurf.noris.de ([192.109.102.42]:39316 "EHLO smurf.noris.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161253AbXBAHYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 02:24:35 -0500
X-Greylist: delayed 1321 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 02:24:35 EST
Date: Thu, 1 Feb 2007 08:01:49 +0100
To: "Patro\, Sumant" <Sumant.Patro@lsi.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_{mm,mbox} cmd timeout
Message-ID: <20070201070149.GQ16848@kiste.smurf.noris.de>
References: <0631C836DBF79F42B5A60C8C8D4E82298ECBCC@NAMAIL2.ad.lsil.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwgQ89ZNnFUwFHTC"
Content-Disposition: inline
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E82298ECBCC@NAMAIL2.ad.lsil.com>
User-Agent: Mutt/1.5.12-2006-07-14
From: Matthias Urlichs <smurf@smurf.noris.de>
X-Smurf-Spam-Score: -2.0 (--)
X-Smurf-Whitelist: +relay_from_hosts
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--rwgQ89ZNnFUwFHTC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Patro, Sumant:
> What I see in the log is cmd timeout(s) and is not related to the patch.
>=20
Ouch.

Any ideas what causes my problem? It's a regression; I tested Ubuntu
Dapper and Edgy install CDs, and it's not worked since the latter.

I can pinpoint the change that triggers the problem more closely if
necessary.

--=20
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
My father was a God-fearing man, but he never missed a copy of the
New York Times, either.
		-- E.B. White

--rwgQ89ZNnFUwFHTC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFFwZBd8+hUANcKr/kRAsN9AJ0WjgKt3P0z5t99qsm8k1H+xIeZdwCdHZIw
8csg6UPaSVc/QvJteNoBcU0=
=76uI
-----END PGP SIGNATURE-----

--rwgQ89ZNnFUwFHTC--
