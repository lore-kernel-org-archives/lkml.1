Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbYGaDwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbYGaDwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbYGaDwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 23:52:23 -0400
Received: from ozlabs.org ([203.10.76.45]:36539 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbYGaDwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 23:52:22 -0400
Subject: Re: [PATCH] ftrace: Make output nicely spaced for up to 999 cpus
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Steven Rostedt <rostedt@goodmis.org>
Cc: srostedt@redhat.com, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080725221124.GA837@goodmis.org>
References: <ea127060ce3764c4b714406be0521171b925a847.1216192501.git.michael@ellerman.id.au>
	 <20080725221124.GA837@goodmis.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cMXAEXPldAwNAayMHsn/"
Date: Thu, 31 Jul 2008 13:52:19 +1000
Message-Id: <1217476339.1487.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cMXAEXPldAwNAayMHsn/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-07-25 at 18:11 -0400, Steven Rostedt wrote:
> On Wed, Jul 16, 2008 at 05:15:01PM +1000, Michael Ellerman wrote:
> >=20
> > Currently some of the ftrace output goes skewiff if you have more
> > than 9 cpus, and some if you have more than 99.
> >=20
> > Twiddle with the headers and format strings to make up to 999 cpus
> > display without causing spacing problems.
> >=20
> > Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
>=20
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Hi Steven,

Is there an ftrace tree I should send this to? Or should I ask Andrew to
throw it in -mm ?

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-cMXAEXPldAwNAayMHsn/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIkTbzdSjSd0sB4dIRAl38AKCmxYVWjHIMUfd7gwcTXELcTVSH2wCgoL39
dLwefBFQW9pJ5bzjY8OFxfk=
=tDWg
-----END PGP SIGNATURE-----

--=-cMXAEXPldAwNAayMHsn/--

