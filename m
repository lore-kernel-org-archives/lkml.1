Return-Path: <linux-kernel-owner+w=401wt.eu-S1762973AbYDOAk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762973AbYDOAk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 20:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbYDOAkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 20:40:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51305 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757645AbYDOAkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 20:40:19 -0400
Date: Tue, 15 Apr 2008 10:40:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Pageflags: Standardize comment inclusion in asm-offsets.h and
 fix MIPS
Message-Id: <20080415104006.81b94170.sfr@canb.auug.org.au>
In-Reply-To: <20080414162924.da6360a4.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0804141140430.7154@schroedinger.engr.sgi.com>
	<20080414133213.82a5b76e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0804141456410.8740@schroedinger.engr.sgi.com>
	<20080414162924.da6360a4.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Apr_2008_10_40_06_+1000_e9AR80UIzqEr6Ara"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Apr_2008_10_40_06_+1000_e9AR80UIzqEr6Ara
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 14 Apr 2008 16:29:24 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> > AFACIT the powerpc=20
> > config is borked because section size is set too low for 64K pages.
>=20
> Yes, the above allmodconfig error was caused by git-powerpc.

I posted a fix the other day ...

http://patchwork.ozlabs.org/linuxppc/patch?id=3D17819

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Apr_2008_10_40_06_+1000_e9AR80UIzqEr6Ara
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIA/luTgG2atn1QN8RAuR3AJ4v6Goqs6IPdwXzTu7xGqziyOiqDQCggk7Q
D7QhGwjXMdYJpaplrdVefB4=
=RUZS
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Apr_2008_10_40_06_+1000_e9AR80UIzqEr6Ara--
