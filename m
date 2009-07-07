Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZGGGpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZGGGpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 02:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZGGGpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 02:45:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34966 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbZGGGp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 02:45:29 -0400
Date: Tue, 7 Jul 2009 16:45:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: linux-next: block tree build failure
Message-Id: <20090707164526.d57bfbda.sfr@canb.auug.org.au>
In-Reply-To: <20090707063846.GY23611@kernel.dk>
References: <20090707134908.e81b1556.sfr@canb.auug.org.au>
	<20090707063846.GY23611@kernel.dk>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Jul_2009_16_45_26_+1000_aQ2_=gw+DnA/Cjo7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Jul_2009_16_45_26_+1000_aQ2_=gw+DnA/Cjo7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Tue, 7 Jul 2009 08:38:46 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
>
> That is correct! I have just now updated for-next as well, so your next
> pull should lose this fixup.

Excellent, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Jul_2009_16_45_26_+1000_aQ2_=gw+DnA/Cjo7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpS7wYACgkQjjKRsyhoI8yFlwCggVJ4NaLkawdoEccpjUkzFsOO
LAIAnAplnX2egfEl1eBAmt0YzZ++G8Zr
=EsMd
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Jul_2009_16_45_26_+1000_aQ2_=gw+DnA/Cjo7--
