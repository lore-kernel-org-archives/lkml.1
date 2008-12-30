Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYL3WyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYL3WyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYL3Wwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:52:38 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45303 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbYL3Wwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:52:37 -0500
Date: Wed, 31 Dec 2008 09:52:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-next@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: linux-next: origin tree build failure
Message-Id: <20081231095228.b21cffe0.sfr@canb.auug.org.au>
In-Reply-To: <20081231024654.a73f20df.sfr@canb.auug.org.au>
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
	<adavdt2ru39.fsf@cisco.com>
	<20081230193048.db7ee462.sfr@canb.auug.org.au>
	<adaljtxsma7.fsf@cisco.com>
	<20081231024654.a73f20df.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__31_Dec_2008_09_52_28_+1100_c.+OHMmt_lebj/xk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__31_Dec_2008_09_52_28_+1100_c.+OHMmt_lebj/xk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Roland,

On Wed, 31 Dec 2008 02:46:54 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Tue, 30 Dec 2008 07:41:36 -0800 Roland Dreier <rdreier@cisco.com> wrot=
e:
> >
> >  > I can drop the revert after your fix goes into Linus' tree (since th=
at is
> >  > where the breakage is) ... looking forward to it, thanks.
> >=20
> > Shouldn't it work if the fix is in my for-next branch, since you pull
> > that as part of the -next tree?  Or am I unclear on how -next works?
>=20
> I also build the tree between merging most of the trees (including after
> fetching Linus' latest tree).

So instead of the revert, I will cherry-pick your fix commit just after
Linus' tree today on the assumption that you will send it to him ASAP.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__31_Dec_2008_09_52_28_+1100_c.+OHMmt_lebj/xk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklapiwACgkQjjKRsyhoI8wsZQCdH555Wj4lEGde/P/NanFwtYxd
8+AAnR5pZ5pA6iMklvChenvpXFoT0BVf
=Q0tM
-----END PGP SIGNATURE-----

--Signature=_Wed__31_Dec_2008_09_52_28_+1100_c.+OHMmt_lebj/xk--
