Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZDMV4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZDMV4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZDMV4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:56:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52846 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZDMV4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:56:07 -0400
Date: Tue, 14 Apr 2009 07:55:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Pull request for nilfs2 tree
Message-Id: <20090414075559.53b648ee.sfr@canb.auug.org.au>
In-Reply-To: <20090413.172931.45933263.ryusuke@osrg.net>
References: <20090413.172931.45933263.ryusuke@osrg.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Apr_2009_07_55_59_+1000_.5uu8lcTLlsu.RP0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Apr_2009_07_55_59_+1000_.5uu8lcTLlsu.RP0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 13 Apr 2009 17:29:31 +0900 (JST) Ryusuke Konishi <konishi.ryusuke@l=
ab.ntt.co.jp> wrote:
>
> Could you consider pulling the for-next branch of this tree:
>=20
>    git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
>=20
> into linux-next, please?

It will be in linux-next starting today.

What I tell everyone: all patches/commits in the tree/series must
have been:

	posted to a relevant mailing list
	reviewed
	unit tested
	destined for the next merge window (or the current release)

*before* they are included.  The linux-next tree is for integration
testing and to lower the impact of conflicts between subsystems in the
next merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Apr_2009_07_55_59_+1000_.5uu8lcTLlsu.RP0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknjtO8ACgkQjjKRsyhoI8zxygCeLb7MPxzZD1ffgUESzwa6IYcG
FoIAniKYA0wTU0N1SoGj+1ygID7wn00r
=A1Cj
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Apr_2009_07_55_59_+1000_.5uu8lcTLlsu.RP0--
