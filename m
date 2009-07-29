Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZG2GR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZG2GR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 02:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZG2GR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 02:17:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57128 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZG2GR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 02:17:56 -0400
Date: Wed, 29 Jul 2009 16:17:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: linux-next: drbd tree build failure
Message-Id: <20090729161750.148374e2.sfr@canb.auug.org.au>
In-Reply-To: <yq1prbk59bv.fsf@sermon.lab.mkp.net>
References: <20090729152938.791a81c3.sfr@canb.auug.org.au>
	<yq1prbk59bv.fsf@sermon.lab.mkp.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Jul_2009_16_17_50_+1000_xvCd_y+sks3xo53H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Jul_2009_16_17_50_+1000_xvCd_y+sks3xo53H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Martin,

On Wed, 29 Jul 2009 01:47:48 -0400 "Martin K. Petersen" <martin.petersen@or=
acle.com> wrote:
>
> >>>>> "Stephen" =3D=3D Stephen Rothwell <sfr@canb.auug.org.au> writes:
>=20
> Stephen> drivers/block/drbd/drbd_nl.c: In function
> Stephen> 'drbd_setup_queue_param': drivers/block/drbd/drbd_nl.c:707:
> Stephen> error: implicit declaration of function
> Stephen> 'blk_queue_stack_limits'
>=20
> We've decided to keep blk_queue_stack_limits as a wrapper to ease the
> transition.  I sent Jens a patch earlier today that does this.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Jul_2009_16_17_50_+1000_xvCd_y+sks3xo53H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpv6Y4ACgkQjjKRsyhoI8yVwwCbBkCYQj7fuUGy5KSTNOP1+ui7
AnkAn3aV4bzsP9fTuA/KZ+xmF8DqhlLr
=mDdM
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Jul_2009_16_17_50_+1000_xvCd_y+sks3xo53H--
