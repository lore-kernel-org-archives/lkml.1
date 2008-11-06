Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYKFAyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYKFAyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 19:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYKFAyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 19:54:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45381 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbYKFAyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 19:54:43 -0500
Date: Thu, 6 Nov 2008 11:54:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       travis@sgi.com
Subject: Re: Git next: Second stage of cpu_alloc patches
Message-Id: <20081106115428.f622e61f.sfr@canb.auug.org.au>
In-Reply-To: <20081105235842.GB10909@cmpxchg.org>
References: <Pine.LNX.4.64.0811042053510.31638@quilx.com>
	<20081104195205.fe1bf62b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811050753120.11867@quilx.com>
	<20081105235842.GB10909@cmpxchg.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__6_Nov_2008_11_54_28_+1100_VvM=bBQ4fT4Xq=Sy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Nov_2008_11_54_28_+1100_VvM=bBQ4fT4Xq=Sy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Nov 2008 00:58:42 +0100 Johannes Weiner <hannes@cmpxchg.org> wrot=
e:
>
> On Wed, Nov 05, 2008 at 07:54:39AM -0600, Christoph Lameter wrote:
> > Ok so post a patchset to lkml and at the same time offer a git tree?
>=20
> Git is perhaps a more convenient way to pick up changesets compared to
> extracting them from emails but review and discussion should still
> happen by Email, no?

Correct.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Nov_2008_11_54_28_+1100_VvM=bBQ4fT4Xq=Sy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEARECAAYFAkkSQEQACgkQjjKRsyhoI8wxvwCgg81Xk9NGVBcitQnmS9n9iRdw
YPkAmIiq5lcQrF0WwQF71Y+/Sh7fClI=
=5o6H
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Nov_2008_11_54_28_+1100_VvM=bBQ4fT4Xq=Sy--
