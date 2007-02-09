Return-Path: <linux-kernel-owner+w=401wt.eu-S2992782AbXBITpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992782AbXBITpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992780AbXBITpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:45:40 -0500
Received: from mx1.suse.de ([195.135.220.2]:57872 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992782AbXBITpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:45:39 -0500
Date: Fri, 9 Feb 2007 20:45:17 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andi Kleen <ak@muc.de>
Cc: Alon Bar-Lev <alon.barlev@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, rmk+lkml@arm.linux.org.uk, vojtech@suse.cz
Subject: Re: [PATCH 18/34] __initdata cleanup - x86_64
Message-ID: <20070209194517.GA25456@strauss.suse.de>
Mail-Followup-To: Andi Kleen <ak@muc.de>,
	Alon Bar-Lev <alon.barlev@gmail.com>, linux-kernel@vger.kernel.org,
	akpm@osdl.org, rmk+lkml@arm.linux.org.uk, vojtech@suse.cz
References: <200702091711.34441.alon.barlev@gmail.com> <200702091724.28770.alon.barlev@gmail.com> <20070209193533.GA79395@muc.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <20070209193533.GA79395@muc.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Andi Kleen <ak@muc.de> [2007-02-09 20:35]:
> On Fri, Feb 09, 2007 at 05:24:28PM +0200, Alon Bar-Lev wrote:
> >=20
> > Trivial.
>=20
> What is this change good for?

It was because http://lkml.org/lkml/2007/1/22/267. But since the
kernel is compiled with -fno-common, it's superflous.


Regards,
Bernhard

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFzM9NiGU2lt2vZFQRAoT8AJ9X0f6ZB9p8XxX3lT8Wezvv+FZNJACgmSYL
QdlF1tqF2wgrpu2l+HJdy34=
=YZ8o
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
