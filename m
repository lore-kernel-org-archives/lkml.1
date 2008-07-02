Return-Path: <linux-kernel-owner+w=401wt.eu-S1762740AbYGBG3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762740AbYGBG3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 02:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759641AbYGBG3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 02:29:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48007 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759605AbYGBG3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 02:29:10 -0400
Date: Wed, 2 Jul 2008 16:29:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Jan Beulich" <jbeulich@novell.com>, <sam@ravnborg.org>,
       <stable@kernel.org>, <llipavsky@suse.cz>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] move __attribute__((__cold__)) functions back into
 final .text section
Message-Id: <20080702162900.2e0ffc90.sfr@canb.auug.org.au>
In-Reply-To: <20080701231717.047d580a.akpm@linux-foundation.org>
References: <48590F41.76E4.0078.0@novell.com>
	<20080701231717.047d580a.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Jul_2008_16_29_00_+1000_K5AqfRho/yyNRvQg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Jul_2008_16_29_00_+1000_K5AqfRho/yyNRvQg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 1 Jul 2008 23:17:17 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> So this is now in Sam's
> git+ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git.
> But it is not in the present linux-next.  Either because Sam added it
> after Stephen pulled Sam's tree, or because something screwed up.

Its in the linux-next tree I have just (in the last 30 minutes) published
(but not yet announced) (tag next-20080702).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Jul_2008_16_29_00_+1000_K5AqfRho/yyNRvQg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhrICwACgkQjjKRsyhoI8ybOACcCxA8HPeIWTXogJTjvnREOCg9
zIgAoJxe6OcSm5wgJU7NUxZ0sBWliNuu
=vn4u
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Jul_2008_16_29_00_+1000_K5AqfRho/yyNRvQg--
