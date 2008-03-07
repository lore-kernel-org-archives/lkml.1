Return-Path: <linux-kernel-owner+w=401wt.eu-S1762087AbYCGCKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762087AbYCGCKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 21:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYCGCKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 21:10:30 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49295 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbYCGCKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 21:10:30 -0500
Date: Fri, 7 Mar 2008 13:10:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 6
Message-Id: <20080307131023.0d46a324.sfr@canb.auug.org.au>
In-Reply-To: <20080306225041.03e02d4a.sfr@canb.auug.org.au>
References: <20080306162606.970aefe1.sfr@canb.auug.org.au>
	<20080306090734.GJ17931@shadowen.org>
	<20080306225041.03e02d4a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_Mar_2008_13_10_23_+1100_ScAXG62up8kK3LpK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Mar_2008_13_10_23_+1100_ScAXG62up8kK3LpK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 6 Mar 2008 22:50:41 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Thu, 6 Mar 2008 09:07:43 +0000 Andy Whitcroft <apw@shadowen.org> wrote:
> >
> > I presume that when you report a build break here that this was somethi=
ng
> > you fixed and we should not see in the tree you released.  By which I m=
ean,
> > if any of our builds fail that is not expected and worth reporting.
>=20
> Correct.  All reports very welcome, thanks.

As a clarification.  The above applies when I report a build break while
I am creating the tree.  I will also report some breakage in post
creation testing.  These latter reports will be left to the responsible
person to fix up (hopefully in a timely manner).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Mar_2008_13_10_23_+1100_ScAXG62up8kK3LpK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH0KQTTgG2atn1QN8RAp/iAJ98coZdv4I9X5jKqDY+DaO/lpHhugCdFrDq
zTpFLxqDTk7AV6DFlXtAzkI=
=HKUl
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Mar_2008_13_10_23_+1100_ScAXG62up8kK3LpK--
