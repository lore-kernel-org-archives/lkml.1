Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYJVAnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYJVAnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 20:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYJVAnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 20:43:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41991 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbYJVAnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 20:43:12 -0400
Date: Wed, 22 Oct 2008 11:43:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, torvalds@linux-foundation.org,
       paulmck@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] byteorder: remove direct includes of
 linux/byteorder/swab[b].h
Message-Id: <20081022114300.0a0589ee.sfr@canb.auug.org.au>
In-Reply-To: <20081021131534.7c084fdb.akpm@linux-foundation.org>
References: <1224523418.31861.4.camel@brick>
	<20081021131534.7c084fdb.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__22_Oct_2008_11_43_00_+1100_K63NYkVnzAzt8tEp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Oct_2008_11_43_00_+1100_K63NYkVnzAzt8tEp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Oct 2008 13:15:34 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> > Andrew, this hunk seems to have been lost when you sent it to Linus, it=
's possible
> > you applied this on top of the -next tree where this file has moved, bu=
t the tests
> > tree hasn't been pulled yet.
> >=20
> > The rest of the patch went into mainline as 1d8cca44b6a244b7e378546d719=
041819049a0f9
> >=20
>=20
> Grump.  It happens sometimes.  People putting stuff into linux-next and
> then not merging it into the next kernel.

The "tests" tree has been requested to be pulled twice (or so) with no
response apparently, so I have now dropped it from the -next tree until
someone decides if we want to integrate it at all.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__22_Oct_2008_11_43_00_+1100_K63NYkVnzAzt8tEp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj+dxQACgkQjjKRsyhoI8zvzQCfeMK/aIjm7gv5qTtIDIDYWwhg
GwkAnA2vbNY589Fxu9w7dMYOv7QkdNP0
=MtdV
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Oct_2008_11_43_00_+1100_K63NYkVnzAzt8tEp--
