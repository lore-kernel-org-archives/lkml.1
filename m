Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbZCJFre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbZCJFre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZCJFrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:47:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40865 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbZCJFrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:47:24 -0400
Date: Tue, 10 Mar 2009 16:47:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: Tree for March 6
Message-Id: <20090310164715.51a4b674.sfr@canb.auug.org.au>
In-Reply-To: <20090306112450.12901a19.akpm@linux-foundation.org>
References: <20090306191311.697e7b97.sfr@canb.auug.org.au>
	<20090306112450.12901a19.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Mar_2009_16_47_15_+1100_4j.JyZ.SVicn/Z=j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Mar_2009_16_47_15_+1100_4j.JyZ.SVicn/Z=j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 6 Mar 2009 11:24:50 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Fri, 6 Mar 2009 19:13:11 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > Dropped trees (temporary):
> > 	rr (build problem)
>=20
> It's quite irritating and somewhat risky when this happens.  It means
> that I have to teporarily drop or rework patches to fix things up.=20
> Then the patch needs to be undropped or unreworked when the offending
> tree gets restored.
>=20
> Is it possible to just drop back to the previous day's version when
> something gets screwed up?

I will try this and see how hard it is.  I have done a few today with no
ill effects (that I have seen yet).

The other side of the coin is that there are some dependencies between
some of the trees that are included in linux-next.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__10_Mar_2009_16_47_15_+1100_4j.JyZ.SVicn/Z=j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm1/uMACgkQjjKRsyhoI8zE5ACfTD5nXW7SBVslIcCsVDkNTF/W
4bQAoISeJ795ipv1rVSg/PN4YMYp9J7L
=+JuH
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Mar_2009_16_47_15_+1100_4j.JyZ.SVicn/Z=j--
