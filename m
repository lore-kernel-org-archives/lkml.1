Return-Path: <linux-kernel-owner+w=401wt.eu-S1751995AbZGNAos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbZGNAos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 20:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbZGNAos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 20:44:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50483 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbZGNAor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 20:44:47 -0400
Date: Tue, 14 Jul 2009 10:44:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: driver-core tree build warning
Message-Id: <20090714104442.4921e2a8.sfr@canb.auug.org.au>
In-Reply-To: <20090713213614.GA16674@kroah.com>
References: <20090713172646.55b9acee.sfr@canb.auug.org.au>
	<20090713175106.d2efbd60.sfr@canb.auug.org.au>
	<20090713171802.GB22728@kroah.com>
	<200907131423.59963.david-b@pacbell.net>
	<20090713213614.GA16674@kroah.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Jul_2009_10_44_42_+1000_exzCSOkQtc9XHbdk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Jul_2009_10_44_42_+1000_exzCSOkQtc9XHbdk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Jul 2009 14:36:14 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Mon, Jul 13, 2009 at 02:23:59PM -0700, David Brownell wrote:
> > On Monday 13 July 2009, Greg KH wrote:
> > > David, care to send patches fixing these warnings?
> >=20
> > Here's a single patch:
>=20
> Now merged and pushed out.  Stephen, this should be now resolved in your
> builds for the next -next tree.

Thanks all.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Jul_2009_10_44_42_+1000_exzCSOkQtc9XHbdk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpb1PoACgkQjjKRsyhoI8zB5ACdE4706A2oTfFBtn6XcFIk7sEj
JZsAnjFBmaIUGSeJlQgBInw51/0Zr5jA
=Bf2W
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Jul_2009_10_44_42_+1000_exzCSOkQtc9XHbdk--
