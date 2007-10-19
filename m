Return-Path: <linux-kernel-owner+w=401wt.eu-S965821AbXJSGeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965821AbXJSGeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 02:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbXJSGeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 02:34:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50591 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbXJSGeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 02:34:08 -0400
Date: Fri, 19 Oct 2007 16:33:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Make advansys depend on CONFIG_VIRT_TO_BUS
Message-Id: <20071019163359.2409613d.sfr@canb.auug.org.au>
In-Reply-To: <20071018223023.d805c8c4.akpm@linux-foundation.org>
References: <20071019150431.996522c5.sfr@canb.auug.org.au>
	<20071018222017.514df7b9.randy.dunlap@oracle.com>
	<20071018223023.d805c8c4.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Oct_2007_16_33_59_+1000_tAUFkayY_.ipfDEA"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Oct_2007_16_33_59_+1000_tAUFkayY_.ipfDEA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Oct 2007 22:30:23 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Thu, 18 Oct 2007 22:20:17 -0700 Randy Dunlap <randy.dunlap@oracle.com>=
 wrote:
> >=20
> > Please explain "why" in the changelog (what changelog?).
> >=20
> > E.g.:
> > so that make allmodconfig on powerpc will have a better chance
> > of building.

Yep, sorry.

> My version of this patch does that.  I'll be sending it into Linus in an
> hour or so.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Oct_2007_16_33_59_+1000_tAUFkayY_.ipfDEA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHGE/bTgG2atn1QN8RAn1+AJ9eVWU+wYtXEyVAbeH3UDDVTkxFMQCgmdcL
jYEw3b2DRKeoxWqyWODdqzs=
=I0mA
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Oct_2007_16_33_59_+1000_tAUFkayY_.ipfDEA--
