Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbXLLCgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbXLLCgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 21:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXLLCgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 21:36:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51372 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbXLLCgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 21:36:38 -0500
Date: Wed, 12 Dec 2007 13:36:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@ORACLE.COM>
Cc: michael@ellerman.id.au, Greg KH <greg@kroah.com>, linuxppc-dev@ozlabs.org,
       "Kyle A. Lucke" <klucke@us.ibm.com>, paulus@samba.org,
       linux-kernel@vger.kernel.org, David Gibson <dwg@au1.ibm.com>
Subject: Re: [PATCH] Introduce driver_create/remove_dir
Message-Id: <20071212133630.7bf1686f.sfr@canb.auug.org.au>
In-Reply-To: <20071211164039.013f4393.randy.dunlap@oracle.com>
References: <20071205093054.GA23229@kroah.com>
	<1196853031.6759.7.camel@concordia>
	<20071205214103.GA7074@kroah.com>
	<1196912898.14754.13.camel@concordia>
	<20071212105633.725496cb.sfr@canb.auug.org.au>
	<20071211164039.013f4393.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Dec_2007_13_36_30_+1100_+.M/mc4RyaeGdNF9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Dec_2007_13_36_30_+1100_+.M/mc4RyaeGdNF9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Dec 2007 16:40:39 -0800 Randy Dunlap <randy.dunlap@ORACLE.COM> w=
rote:
>
> On Wed, 12 Dec 2007 10:56:33 +1100 Stephen Rothwell wrote:
>=20
> > +/**
> > + *	driver_remove_dir - remove a subdirectory for a driver.
> > + *	@drv:	driver.
> > + *	@attr:	driver attribute descriptor.
>=20
> Second arg below is @kobj.

Thanks, will fix (cut and paste error).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__12_Dec_2007_13_36_30_+1100_+.M/mc4RyaeGdNF9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHX0kzTgG2atn1QN8RAvFWAKCRDJok+1WJSlgatPbCUoIMjhAWHQCbBPgU
RQ5YyESvYZbSvO1UPqPpoO0=
=fi6Y
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Dec_2007_13_36_30_+1100_+.M/mc4RyaeGdNF9--
