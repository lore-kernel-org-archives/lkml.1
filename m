Return-Path: <linux-kernel-owner+w=401wt.eu-S1763809AbYBVHEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763809AbYBVHEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 02:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYBVHEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 02:04:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54355 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbYBVHEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 02:04:42 -0500
Date: Fri, 22 Feb 2008 18:04:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Frank Seidel <fseidel@suse.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 22
Message-Id: <20080222180438.6b98ef9b.sfr@canb.auug.org.au>
In-Reply-To: <47BE6F2E.4080704@suse.de>
References: <20080222170421.9e17d143.sfr@canb.auug.org.au>
	<47BE6F2E.4080704@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_Feb_2008_18_04_38_+1100_T7vg4kR6NnjcscaK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Feb_2008_18_04_38_+1100_T7vg4kR6NnjcscaK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Frank,

On Fri, 22 Feb 2008 07:43:58 +0100 Frank Seidel <fseidel@suse.de> wrote:
>
> at least the bz2 tar i just looked at from that URL has a problem
> with the prefix resulting to this toplevel extraction:
>=20
> next-20080222arch
> next-20080222block
> ...
> next-20080222virt
>=20
> So, i guess you just missed the trailing slash for the prefix
> parameter of git archive?
> (should be --prefix=3Dnext-20080222/ afaik)

Indeed.  Thanks. I am regenerating them now.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__22_Feb_2008_18_04_38_+1100_T7vg4kR6NnjcscaK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHvnQJTgG2atn1QN8RAjLQAKCD5xdsdrtk3JPH66kMZNKJ0Z4CdgCdFuCK
O0+tIMtRrOkjyZuz9sJud84=
=Kwys
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Feb_2008_18_04_38_+1100_T7vg4kR6NnjcscaK--
