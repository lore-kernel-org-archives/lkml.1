Return-Path: <linux-kernel-owner+w=401wt.eu-S1751712AbZGaFuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbZGaFuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 01:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZGaFuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 01:50:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45684 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZGaFuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 01:50:11 -0400
Date: Fri, 31 Jul 2009 15:50:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: linux-next: manual merge of the reiserfs-bkl tree with Linus'
 tree
Message-Id: <20090731155004.c151e2ce.sfr@canb.auug.org.au>
In-Reply-To: <20090731050505.GA6115@nowhere>
References: <20090713115114.a871ea68.sfr@canb.auug.org.au>
	<20090731050505.GA6115@nowhere>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__31_Jul_2009_15_50_04_+1000_6_gkFS3oduIC7MdC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__31_Jul_2009_15_50_04_+1000_6_gkFS3oduIC7MdC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Frederic,

On Fri, 31 Jul 2009 07:05:07 +0200 Frederic Weisbecker <fweisbec@gmail.com>=
 wrote:
>
> I've pushed the latest update/rebase of the reiserfs/kill-bkl tree
> there:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git=
 \
> reiserfs/kill-bkl

Thanks.

> I've changed the branch name because the previous one had a fixed rc vers=
ion
> inside. This new branch will keep beeing the most up to date.
> Could you please drop the old branch and integrate this new one?

OK, I will fetch the new branch starting on Monday.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__31_Jul_2009_15_50_04_+1000_6_gkFS3oduIC7MdC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpyhgwACgkQjjKRsyhoI8wK7QCfYIwDmpooKSxnpzeHRZeiBWWD
w0YAoItnqtOTtjp3KyR+QZTSsq+S7oQL
=pxFR
-----END PGP SIGNATURE-----

--Signature=_Fri__31_Jul_2009_15_50_04_+1000_6_gkFS3oduIC7MdC--
