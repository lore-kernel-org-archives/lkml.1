Return-Path: <linux-kernel-owner+w=401wt.eu-S1760326AbYDZRdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326AbYDZRdh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYDZRda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:33:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39176 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbYDZRda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:33:30 -0400
Date: Sun, 27 Apr 2008 03:33:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: optimized inlining
Message-Id: <20080427033321.0e973d12.sfr@canb.auug.org.au>
In-Reply-To: <20080424095932.70c87714.sfr@canb.auug.org.au>
References: <20080424095932.70c87714.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta2 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__27_Apr_2008_03_33_21_+1000__sgfp+PY5zUZJfU."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__27_Apr_2008_03_33_21_+1000__sgfp+PY5zUZJfU.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Thu, 24 Apr 2008 09:59:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Could you please merge your two patches "x86: add optimized inlining" and
> "generic: optimized inlining, fix" before you send them to Linus.  This
> way we won't have another bad spot to land while bisecting on powerpc.
>=20
> Thanks.

I take it as a "no".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__27_Apr_2008_03_33_21_+1000__sgfp+PY5zUZJfU.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIE2dmTgG2atn1QN8RAvZBAJ9o9sI31RhgjttaQgqzL5SjLRKpnQCgiHUz
i/JAHN7dF1eDmP4ZcjOqqWk=
=ZAOz
-----END PGP SIGNATURE-----

--Signature=_Sun__27_Apr_2008_03_33_21_+1000__sgfp+PY5zUZJfU.--
