Return-Path: <linux-kernel-owner+w=401wt.eu-S1760447AbXKMFL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbXKMFL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 00:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbXKMFLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 00:11:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58034 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbXKMFLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 00:11:46 -0500
Date: Tue, 13 Nov 2007 16:11:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: David <david@unsolicited.net>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-rc1 - Regularly getting processes stuck in D state on
 startup
Message-Id: <20071113161145.6433e1c1.sfr@canb.auug.org.au>
In-Reply-To: <394418014.24002@ustc.edu.cn>
References: <472F5F8B.7090200@unsolicited.net>
	<E1IpJLy-0002ag-TL@localhost>
	<394337271.18157@ustc.edu.cn>
	<20071107141717.6eb0dc25.sfr@canb.auug.org.au>
	<20071107142609.071532ad.sfr@canb.auug.org.au>
	<394418014.24002@ustc.edu.cn>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Nov_2007_16_11_45_+1100_iMoYIdrJy9zD92Uc"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Nov_2007_16_11_45_+1100_iMoYIdrJy9zD92Uc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Nov 2007 14:46:47 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
>
> Thank you(including David:-)) for the confirmation.
>=20
> Andrew: so mm-speed-up-writeback-ramp-up-on-clean-systems.patch is a
> safe and working patch ;-)

So is anything happening with this patch?  It is really necessary to have
it (or something equivalent) in 2.6.24.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Nov_2007_16_11_45_+1100_iMoYIdrJy9zD92Uc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHOTIVTgG2atn1QN8RAuqoAJ9bM213jG3sYj9CQZzRUqqunCmM2wCgiPYQ
11OpF9BfpFne7+cUQiEG7UI=
=cNGW
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Nov_2007_16_11_45_+1100_iMoYIdrJy9zD92Uc--
