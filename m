Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbZDBBcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbZDBBcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 21:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZDBBcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 21:32:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39625 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZDBBca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 21:32:30 -0400
Date: Thu, 2 Apr 2009 12:32:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Invalid module format (was: Re: linux-next: Tree for April 1)
Message-Id: <20090402123223.f31370cd.sfr@canb.auug.org.au>
In-Reply-To: <20090401150928.GA5886@denkbrett.schottelius.org>
References: <20090401164450.f8192631.sfr@canb.auug.org.au>
	<20090401150928.GA5886@denkbrett.schottelius.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__2_Apr_2009_12_32_23_+1100_ZRBqh2POZtepnnaC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Apr_2009_12_32_23_+1100_ZRBqh2POZtepnnaC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nico,

On Wed, 1 Apr 2009 17:09:28 +0200 Nico -telmich- Schottelius <nico-linux-ne=
xt@schottelius.org> wrote:
>
> Stephen Rothwell [Wed, Apr 01, 2009 at 04:44:50PM +1100]:
> >=20
> > Changes since 20090331:
>=20
> Same problem since 20090324.
>=20
> arch=3Damd64, config attached, all modules have that problem.

Does Linus' kernel with this config show the problem?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__2_Apr_2009_12_32_23_+1100_ZRBqh2POZtepnnaC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknUFacACgkQjjKRsyhoI8wumwCcCMe5phSOpDxjzFVcG/N4w6Wv
GKQAoIR+Vv7/pt0wJ7WOn1Ee6GPikBOD
=6sXP
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Apr_2009_12_32_23_+1100_ZRBqh2POZtepnnaC--
