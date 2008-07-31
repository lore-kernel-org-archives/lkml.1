Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbYGaEI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbYGaEI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 00:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYGaEID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 00:08:03 -0400
Received: from ozlabs.org ([203.10.76.45]:58012 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbYGaEIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 00:08:02 -0400
Subject: Re: [PATCH] ftrace: Make output nicely spaced for up to 999 cpus
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, srostedt@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080730210144.0f4970c9.akpm@linux-foundation.org>
References: <ea127060ce3764c4b714406be0521171b925a847.1216192501.git.michael@ellerman.id.au>
	 <20080725221124.GA837@goodmis.org> <1217476339.1487.24.camel@localhost>
	 <20080730210144.0f4970c9.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZDbh60Io1DlmXu5mt6pD"
Date: Thu, 31 Jul 2008 14:07:59 +1000
Message-Id: <1217477279.1487.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZDbh60Io1DlmXu5mt6pD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-30 at 21:01 -0700, Andrew Morton wrote:
> On Thu, 31 Jul 2008 13:52:19 +1000 Michael Ellerman <michael@ellerman.id.=
au> wrote:
>=20
> > On Fri, 2008-07-25 at 18:11 -0400, Steven Rostedt wrote:
> > > On Wed, Jul 16, 2008 at 05:15:01PM +1000, Michael Ellerman wrote:
> > > >=20
> > > > Currently some of the ftrace output goes skewiff if you have more
> > > > than 9 cpus, and some if you have more than 99.
> > > >=20
> > > > Twiddle with the headers and format strings to make up to 999 cpus
> > > > display without causing spacing problems.
> > > >=20
> > > > Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> > >=20
> > > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>=20
> I switched that to Acked-by:.  A Signed-off-by: implies that you
> (co)authored the patch or that it went through your hands.  That does
> not appear to be the case here.

Yep, acked-by is right here.

> > Hi Steven,
> >=20
> > Is there an ftrace tree I should send this to? Or should I ask Andrew t=
o
> > throw it in -mm ?
>=20
> Normally Ingo handles ftrace but he will shortly be offline for a bit,
> so I'll suck up whatever Ingoish things happen to cross my desk.

Thanks. I take it the patch still applies, if not yell and I'll send you
a new version.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-ZDbh60Io1DlmXu5mt6pD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIkTqfdSjSd0sB4dIRApM9AKCwgbqVGFPpWFqs+o13q1pYMiSKPQCeMfhQ
kvf5mD+hSE8iymIKFZ2o/qE=
=8S6K
-----END PGP SIGNATURE-----

--=-ZDbh60Io1DlmXu5mt6pD--

