Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbZIAFau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbZIAFau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 01:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZIAFat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 01:30:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57687 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbZIAFat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 01:30:49 -0400
Date: Tue, 1 Sep 2009 15:30:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: linux-next: block tree build failure
Message-Id: <20090901153038.807f5586.sfr@canb.auug.org.au>
In-Reply-To: <20090901145949.58610c23.sfr@canb.auug.org.au>
References: <20090901145949.58610c23.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Sep_2009_15_30_38_+1000_nqZbn98Kiik/Phkx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Sep_2009_15_30_38_+1000_nqZbn98Kiik/Phkx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

On Tue, 1 Sep 2009 14:59:49 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> I have used the version of the block tree from next-20090831 for today.

Which means that I have had to use yesterday's version of the
device-mapper tree as well (since it is based on the block tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Sep_2009_15_30_38_+1000_nqZbn98Kiik/Phkx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqcsX4ACgkQjjKRsyhoI8xUZACfd6LonBSgkwsOLl35nz4s1ZEa
KFcAn18bJJjP7O+o3/mbfYlXYccULejm
=DGQD
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Sep_2009_15_30_38_+1000_nqZbn98Kiik/Phkx--
