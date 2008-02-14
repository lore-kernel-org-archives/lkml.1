Return-Path: <linux-kernel-owner+w=401wt.eu-S934985AbYBNXsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934985AbYBNXsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934852AbYBNXny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:43:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40479 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934388AbYBNXnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:43:52 -0500
Date: Fri, 15 Feb 2008 10:43:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Alasdair G Kergon <agk@redhat.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: linux-next: quilt series
Message-Id: <20080215104346.93c10058.sfr@canb.auug.org.au>
In-Reply-To: <20080214084233.82728ab6.randy.dunlap@oracle.com>
References: <20080215014210.73c71078.sfr@canb.auug.org.au>
	<20080214084233.82728ab6.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Feb_2008_10_43_46_+1100_TZe.GuJvkKzJqM3R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2008_10_43_46_+1100_TZe.GuJvkKzJqM3R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Thu, 14 Feb 2008 08:42:33 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> On Fri, 15 Feb 2008 01:42:10 +1100 Stephen Rothwell wrote:
>=20
> > Also, if you only want a subset of the series file included, you can ma=
rk the patches with
> >=20
> > # NEXT_PATCHES_START
> > 	.
> > 	.
> > # NEXT_PATCHES_END
>=20
> Do you allow multiple START/END blocks?

I can and certainly intended to. (I am still writing scripts so anything
is possible - after all it is only software :-))

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__15_Feb_2008_10_43_46_+1100_TZe.GuJvkKzJqM3R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtNI3TgG2atn1QN8RAt19AKCHrP953Y+c735GchvH16+tWETNtwCffviI
S9CQ8ksCZHemo77CKs1YTGk=
=80HY
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2008_10_43_46_+1100_TZe.GuJvkKzJqM3R--
