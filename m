Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760022AbYLQIAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbYLQIAh (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 03:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYLQIA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 03:00:26 -0500
Received: from RedStar.dorchain.net ([212.88.133.153]:40026 "EHLO
	Redstar.dorchain.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbYLQIAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 03:00:25 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 Redstar.dorchain.net mBH806wD014706
Date: Wed, 17 Dec 2008 09:00:05 +0100
From: Joerg Dorchain <joerg@dorchain.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joerg Dorchain <joerg@dorchain.net>, Andreas Bombe <aeb@debian.org>,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amiflop: get rid of sleep_on calls
Message-ID: <20081217080005.GN30213@Redstar.dorchain.net>
References: <1228755578-26069-1-git-send-email-aeb@debian.org> <20081209082608.GA10651@Redstar.dorchain.net> <Pine.LNX.4.64.0812162119330.29433@anakin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qoTlaiD+Y2fIM3Ll"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812162119330.29433@anakin>
X-message-flag: Formating hard disk. please wait...   10%...  20%...
X-Bindford: 6200 (more Power!)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qoTlaiD+Y2fIM3Ll
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2008 at 09:23:00PM +0100, Geert Uytterhoeven wrote:
> >=20
> > At first glance, the patch looks ok.
>=20
> Does that mean I can add your Acked-by?

Yes. Although real world testing would be nice, though.

Bye,

Joerg

--qoTlaiD+Y2fIM3Ll
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklIsYUACgkQjY4+4PdzvODOgACfY9W/8N8ligpNbYtVtcR5Cfau
ZicAn3N2nWCr+vJCRM2ongcylfOD8wDb
=1tgK
-----END PGP SIGNATURE-----

--qoTlaiD+Y2fIM3Ll--
