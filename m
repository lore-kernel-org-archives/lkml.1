Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573Ab0AEDmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab0AEDmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 22:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527Ab0AEDl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 22:41:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37279 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab0AEDlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 22:41:55 -0500
Date: Tue, 5 Jan 2010 14:41:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: pci tree build failure
Message-Id: <20100105144150.434f9626.sfr@canb.auug.org.au>
In-Reply-To: <20100104154843.294c06ff@jbarnes-piketon>
References: <20100105095543.8c446cb7.sfr@canb.auug.org.au>
	<20100104231001.GF9882@parisc-linux.org>
	<20100104154843.294c06ff@jbarnes-piketon>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Jan_2010_14_41_50_+1100_ScczRLF1yUMHtSHh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Jan_2010_14_41_50_+1100_ScczRLF1yUMHtSHh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

On Mon, 4 Jan 2010 15:48:43 -0800 Jesse Barnes <jbarnes@virtuousgeek.org> w=
rote:
>
> > Doh, sorry.  I don't have a handy powerpc environment around to test
> > with. Can you try just deleting line 433?  (this should actually be
> > the correct fix).
>=20
> I just pushed that into my linux-next tree.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Jan_2010_14_41_50_+1100_ScczRLF1yUMHtSHh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktCtP4ACgkQjjKRsyhoI8zFjgCePkEyFSIv+zX0Qmvpzj7q21SE
dswAn1S8OrMUwuU+TMMTwgUdqrqoBPLo
=8GcF
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Jan_2010_14_41_50_+1100_ScczRLF1yUMHtSHh--
