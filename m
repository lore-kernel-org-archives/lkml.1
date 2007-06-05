Return-Path: <linux-kernel-owner+w=401wt.eu-S1764980AbXFEPBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764980AbXFEPBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763236AbXFEPBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:01:31 -0400
Received: from ozlabs.org ([203.10.76.45]:36189 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbXFEPBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:01:30 -0400
Subject: Re: [2/2] 2.6.22-rc4: known regressions with patches
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Greg KH <greg@kroah.com>,
       "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
In-Reply-To: <4665792B.8030005@googlemail.com>
References: <46657866.7000108@googlemail.com>
	 <4665792B.8030005@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qtsJ+o4a23yzxJf21BuP"
Date: Wed, 06 Jun 2007 01:01:28 +1000
Message-Id: <1181055688.8910.3.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qtsJ+o4a23yzxJf21BuP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-06-05 at 16:54 +0200, Michal Piotrowski wrote:
> Hi all,
>=20
> Here is a list of some known regressions in 2.6.22-rc4
> with patches available.
>=20
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
>=20
>=20
>=20
> PCI
>=20
> Subject    : Oops on 2.6.22-rc2 when unloading the cciss driver
> References : http://lkml.org/lkml/2007/5/24/172
> Submitter  : Mike Miller (OS Dev) <mikem@beardog.cca.cpqcorp.net>
> Patch      : http://lkml.org/lkml/2007/5/31/387
> Status     : patch available

Fixed in Linus' tree since Fri, 1 Jun 2007:
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
it;h=3D78b7611c4a1e3ff008abc4751b566cb533d68f3d

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-qtsJ+o4a23yzxJf21BuP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGZXrIdSjSd0sB4dIRAleBAKCwusm3Sbgd+RwyC3qdVnWmu2h2LQCgwCzc
SGDLPkOsCC9FvXAKyss+fk8=
=ZCqH
-----END PGP SIGNATURE-----

--=-qtsJ+o4a23yzxJf21BuP--

