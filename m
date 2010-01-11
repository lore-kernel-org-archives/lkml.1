Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839Ab0AKItJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab0AKItJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 03:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642Ab0AKItI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 03:49:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47518 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0AKItH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 03:49:07 -0500
Date: Mon, 11 Jan 2010 19:49:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, macro@linux-mips.org,
       hartleys@visionengravers.com
Subject: Re: linux-next: net tree build failure
Message-Id: <20100111194900.fbf6ab0d.sfr@canb.auug.org.au>
In-Reply-To: <20100111.004436.217049216.davem@davemloft.net>
References: <20100111184205.8d53fe5b.Stephen@Rothwell.id.au>
	<20100111.000205.164473435.davem@davemloft.net>
	<1263197772.1907.44.camel@Joe-Laptop.home>
	<20100111.004436.217049216.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__11_Jan_2010_19_49_00_+1100_gwnwgHngHnne3Feg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Jan_2010_19_49_00_+1100_gwnwgHngHnne3Feg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave, Joe,

On Mon, 11 Jan 2010 00:44:36 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Joe Perches <joe@perches.com>
> Date: Mon, 11 Jan 2010 00:16:12 -0800
>=20
> > Perhaps it'd be better to kill off the use of bitrev in
> > lib/vsprintf as Maciej thinks it broken.
> >=20
> > Maybe use something like this?
> >=20
> > Signed-off-by: Joe Perches <joe@perches.com>
>=20
> Yeah that sounds like a better idea, I think I'll commit
> this instead.

Thanks guys.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__11_Jan_2010_19_49_00_+1100_gwnwgHngHnne3Feg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktK5fwACgkQjjKRsyhoI8y9NgCfZu0VzT1v782y61nZhsRapkF1
xCQAn2jPbNRhzPMNJptm2SLGJw9UnQfu
=Jgf6
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Jan_2010_19_49_00_+1100_gwnwgHngHnne3Feg--
