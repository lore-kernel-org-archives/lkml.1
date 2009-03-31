Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbZCaV7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbZCaV7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbZCaV6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:58:50 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:58065 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbZCaV6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:58:49 -0400
Subject: Re: enabling kms for i915 disables brightness control and xrandr
From: Eric Anholt <eric@anholt.net>
To: Soeren Sonnenburg <sonne@debian.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1238328040.4185.62.camel@localhost>
References: <1238322841.4185.36.camel@localhost>
	 <20090329110143.GA9591@sucs.org>  <1238328040.4185.62.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RVjmhOUIHPSW82lBI5+N"
Date: Tue, 31 Mar 2009 14:58:43 -0700
Message-Id: <1238536723.8369.534.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RVjmhOUIHPSW82lBI5+N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-29 at 14:00 +0200, Soeren Sonnenburg wrote:
> On Sun, 2009-03-29 at 12:01 +0100, Sitsofe Wheeler wrote:
> > On Sun, Mar 29, 2009 at 12:34:01PM +0200, Soeren Sonnenburg wrote:
> > >=20
> > > I am not sure if this is just a user error/ too old userspace problem=
,
> >=20
> > Which version of X intel driver are you running?
> > http://lkml.org/lkml/2009/2/27/363 suggests you will have unsupported
> > problems unless it is 2.6.2 or higher...
>=20
> Using 2.6.3 things became a lot faster with UXA, but the brightness
> (only possible to set via setpci) and xrandr problems (modes missing)
> are still there...

KMS property control in the 2D driver was introduced recently, and
should be in 2.7, think.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-RVjmhOUIHPSW82lBI5+N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknSkhMACgkQHUdvYGzw6vfO6QCfezmpwvAD7Mf8v84AV0Ty/+fT
ZVkAn1DU2XJMTBc93GAMSt34LcQXZDoW
=l7DM
-----END PGP SIGNATURE-----

--=-RVjmhOUIHPSW82lBI5+N--

