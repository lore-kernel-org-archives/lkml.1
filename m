Return-Path: <linux-kernel-owner+w=401wt.eu-S1752428AbZIWL5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbZIWL5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 07:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZIWL5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 07:57:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50959 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbZIWL5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 07:57:05 -0400
Date: Wed, 23 Sep 2009 21:56:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@lists.linbit.com,
       Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: block tree build failure
Message-Id: <20090923215659.2869830d.sfr@canb.auug.org.au>
In-Reply-To: <20090923111225.GC8000@barkeeper1-xen.linbit>
References: <20090923145100.1917fdd8.sfr@canb.auug.org.au>
	<20090923071152.GA8000@barkeeper1-xen.linbit>
	<20090923111225.GC8000@barkeeper1-xen.linbit>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Sep_2009_21_56_59_+1000_w7R_=bQd.7aXcUls"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Sep_2009_21_56_59_+1000_w7R_=bQd.7aXcUls
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lars,

On Wed, 23 Sep 2009 13:12:25 +0200 Lars Ellenberg <lars.ellenberg@linbit.co=
m> wrote:
>
> Sorry that it took me so long to have that look.
> We can simply drop that include, we don't even use it.

OK, great.  I guess Jens needs to remerge your tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Sep_2009_21_56_59_+1000_w7R_=bQd.7aXcUls
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkq6DQsACgkQjjKRsyhoI8zzbQCgpilFr7Gbdiv59BTo3arCrv+0
ynIAn3aNSg5+vQiMsV5lt7dr88Bz2cnW
=e9Gn
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Sep_2009_21_56_59_+1000_w7R_=bQd.7aXcUls--
