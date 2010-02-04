Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab0BDUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:09:59 -0500
Received: from nn7.de ([85.214.94.156]:55227 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932988Ab0BDUJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:09:56 -0500
Subject: Re: [Bug #15043] Display goes off with i915.powersave=1
From: Soeren Sonnenburg <sonne@debian.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <20100127095734.6c1afc10@jbarnes-piketon>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	 <hE3x9c-4KZM.A.XwF.VKMXLB@chimera>
	 <20100127095734.6c1afc10@jbarnes-piketon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-z1CqYJwn/iHDDF8b0JEr"
Date: Thu, 04 Feb 2010 21:09:53 +0100
Message-ID: <1265314193.10203.1.camel@no>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-z1CqYJwn/iHDDF8b0JEr
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-01-27 at 09:57 -0800, Jesse Barnes wrote:
> On Sun, 24 Jan 2010 23:04:37 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>=20
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >=20
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me kno=
w
> > (either way).
> >=20
> >=20
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D15043
> > Subject		: Display goes off with i915.powersave=3D1
> > Submitter	: Soeren Sonnenburg <sonne@debian.org>
> > Date		: 2010-01-10 20:09 (15 days old)
> > References	: http://marc.info/?l=3Dlinux-kernel&m=3D126315457519505&w=
=3D4
>=20
> If this isn't fixed yet, I hope David's patch fixes it.  See "[Bug
> #14897] i915: Commit 0e442c60 causes flickering".

ok, so it is not fixed yet - I will try to unapply 0e442c60

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-z1CqYJwn/iHDDF8b0JEr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJLaymRAAoJEH82z1Wqh6p3fmgP/jKgFfk8uY9LclvATQhVAOFx
d0/CUQvVsjkM+crkrLCeYcwu4vcXXtLVxLesXPBvpepfxTlm0WUFa0SnWQLkzDZd
inE5ldNvgqR1Aw+3Qjq4swKssnAT7VBF4oLyKbOSPINbT0gAO5Ei3TpZVFka5DLN
EDOINHS+e/tKOmBRfdb3XlzIP5OSItlx4foY0rkZawrLkZzxi8x5MYfl2MJqQbhw
aLuC+DJUXQY3MCNK4BQVLKoJcSQH3xof4aDLaUhLxRWyEDtK70PSxxzoAHW6UcOa
yqBx+DWX9zX/D4BOdwiD+VHVIeGn8BEutPT9ZxN//eXnHMTsG1eLujnypwlkpWax
+NrnfJMYvwy1uu8/rd8lL2C7Rf1AuG4rwYK7uOvCbTk91mY3de2hAKT6qLD6Bc2q
qSVKxNFYXov4JDEGCIqU/bZnJnfIeQvQoYVsURzIU5H1ivr/apLFoL9eJOEywaP0
Vdui1lSNVUR0s5VQupffuiTdNG9FCEtvI8KXl2kutCVjxeL0cNI+8Iyp37dFlP+P
obt3KaqXT43mstDckZS8InbB4fw70p/E5k3Qhlu4b+iZXu3cdUIY5ImlcXGr8ug/
Owf4f3Xk4SjIXD4xAxYB1aFnZtgrkYf1oAc6vc4stR/3s4cZiP0ozJQ4LD4Zkcl2
CtZitmH3s/T0cMROOhKk
=Rb6g
-----END PGP SIGNATURE-----

--=-z1CqYJwn/iHDDF8b0JEr--
