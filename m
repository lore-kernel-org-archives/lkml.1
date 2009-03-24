Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZCXWmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZCXWmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZCXWmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:42:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54097 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbZCXWmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:42:09 -0400
Date: Wed, 25 Mar 2009 09:41:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Invalid module format: Re: linux-next: Tree for March 24
Message-Id: <20090325094159.8dad1d49.sfr@canb.auug.org.au>
In-Reply-To: <20090324170215.GB5495@denkbrett.schottelius.org>
References: <20090324183024.59260457.sfr@canb.auug.org.au>
	<20090324170215.GB5495@denkbrett.schottelius.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_Mar_2009_09_41_59_+1100_Y+mtD0Rt+/qMpnk3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Mar_2009_09_41_59_+1100_Y+mtD0Rt+/qMpnk3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nico,

On Tue, 24 Mar 2009 18:02:15 +0100 Nico -telmich- Schottelius <nico-linux-n=
ext@schottelius.org> wrote:
>
>=20
> My system does not bootup, as I cannot load the crypto modules,
> because it says
>=20
>   Invalid module format

Architecture? config? any other boot messages? Is it just the crypto
modules?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_Mar_2009_09_41_59_+1100_Y+mtD0Rt+/qMpnk3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknJYbgACgkQjjKRsyhoI8yD7gCeNXt52rfyf4UbazQRnzLVGtsr
DMwAoIjLBUgcuq+Z4oAPfg2sdP9UxWme
=zuXw
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Mar_2009_09_41_59_+1100_Y+mtD0Rt+/qMpnk3--
