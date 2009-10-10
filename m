Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZJJJDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZJJJDo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 05:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbZJJJDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 05:03:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48098 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZJJJDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 05:03:41 -0400
Date: Sat, 10 Oct 2009 11:03:02 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       devicetree-discuss@ozlabs.org, Grant Likely <grant.likely@secretlab.ca>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [RFC] scripts/get_maintainer: add emails based on keywords in
	the patch
Message-ID: <20091010090302.GA11576@pengutronix.de>
References: <1255084379-12954-1-git-send-email-w.sang@pengutronix.de> <1255087406.16347.108.camel@Joe-Laptop.home> <1255114905.16347.137.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <1255114905.16347.137.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Perhaps it's better to use the existing MAINTAINERS file
> and extend it with a new "K:" for keyword entry.

Yeah, makes sense to have everything in one file.

> +	K: Keyword perl regex pattern to match content in patch
> +	   All patterns are surrounded by "\b"
> +	   for instance: K: of_get_profile
> +	   will match patches that contain the word "of_get_profile"

=2E..in the lines which are changed?

> +OPEN FIRMWARE DEVICE TREE
> +L:	devicetree-discuss@lists.ozlabs.org
> +S:	Odd Fixes

Maintained, I'd say. Especially as Grant Likely recently said he wants to t=
ake care about OF.

> +K:	of_get_property

F: drivers/of/

Will check the script later this weekend.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrQTcYACgkQD27XaX1/VRucqQCfZdjsp0AVO2Y30Kcc4U0WFp2N
lXIAoIwf4CTFMevnXhrpIHOgfc685loC
=4dNO
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
