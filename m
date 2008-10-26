Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYJZIel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYJZIel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 04:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYJZIec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 04:34:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46901 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbYJZIeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 04:34:31 -0400
Date: Sun, 26 Oct 2008 19:34:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com
Subject: Re: linux-next: left over things in linux-next after 2.6.28-c1
Message-Id: <20081026193421.f5f7d8f1.sfr@canb.auug.org.au>
In-Reply-To: <20081026081717.GB20872@infradead.org>
References: <20081026005009.50dbbb33.sfr@canb.auug.org.au>
	<20081026081717.GB20872@infradead.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__26_Oct_2008_19_34_21_+1100_xZ0EeMF.nQ025+qE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__26_Oct_2008_19_34_21_+1100_xZ0EeMF.nQ025+qE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 26 Oct 2008 04:17:17 -0400 Christoph Hellwig <hch@infradead.org> wr=
ote:
>
> On Sun, Oct 26, 2008 at 12:50:09AM +1100, Stephen Rothwell wrote:
> > xfs
>=20
> While there are still a lot of patches in the queue (no merge yet for
> .28) this list contains all the patches back to at least early 2008,
> with the big majority merged of course.

Presumably what was merged was slightly different (or the commits were
split up differently).  This is the same problem I have with the kvm tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__26_Oct_2008_19_34_21_+1100_xZ0EeMF.nQ025+qE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkEK40ACgkQjjKRsyhoI8wUowCdEThJbBvTBWJtzUAprn/bBxoa
p0YAoKdzLwhi4cdlO3zRccxYSkZ4W+ig
=pHpD
-----END PGP SIGNATURE-----

--Signature=_Sun__26_Oct_2008_19_34_21_+1100_xZ0EeMF.nQ025+qE--
