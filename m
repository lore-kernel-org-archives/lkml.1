Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZERXgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZERXgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 19:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZERXgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 19:36:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50495 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbZERXgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 19:36:41 -0400
Date: Tue, 19 May 2009 09:36:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: linux-next: Tree for May 15
Message-Id: <20090519093636.329c4708.sfr@canb.auug.org.au>
In-Reply-To: <20090518094822.GB4905@aftab>
References: <20090515153733.4384db9f.sfr@canb.auug.org.au>
	<20090515130729.GA13026@aftab>
	<20090518000734.6fd3d652.sfr@canb.auug.org.au>
	<20090518094822.GB4905@aftab>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_May_2009_09_36_36_+1000_+eSWqH0akSo08nj."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_May_2009_09_36_36_+1000_+eSWqH0akSo08nj.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boris,

On Mon, 18 May 2009 11:48:22 +0200 Borislav Petkov <borislav.petkov@amd.com=
> wrote:
>
> It is an EDAC module for AMD k8, Fam10h and Fam11h processors.

OK, so I will call it edac-amd (in case we ever get a generic edac tree).

> > If so, you are not listed as a maintainer of that code (Doug cc'd).
>=20
> I'll send a patch to update that later.

Thanks for all the info - I just had no idea where this was coming from.

I will add the tree from today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__19_May_2009_09_36_36_+1000_+eSWqH0akSo08nj.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoR8QQACgkQjjKRsyhoI8y0WwCgiE+dbDfvztYEqNbJSbVism6Q
GpMAnRNmSWzUCGiIsjcOUJ59asojy9gr
=d2hV
-----END PGP SIGNATURE-----

--Signature=_Tue__19_May_2009_09_36_36_+1000_+eSWqH0akSo08nj.--
