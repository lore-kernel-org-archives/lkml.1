Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZIOGxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZIOGxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 02:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbZIOGxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 02:53:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52147 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758109AbZIOGxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 02:53:13 -0400
Date: Tue, 15 Sep 2009 16:53:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: linux-next: drbd tree build failure
Message-Id: <20090915165309.f07381ec.sfr@canb.auug.org.au>
In-Reply-To: <20090915062306.GP14984@kernel.dk>
References: <20090915160739.86e85ab3.sfr@canb.auug.org.au>
	<20090915062306.GP14984@kernel.dk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Sep_2009_16_53_09_+1000_9zeGCNmYicgvW.+V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Sep_2009_16_53_09_+1000_9zeGCNmYicgvW.+V
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Tue, 15 Sep 2009 08:23:06 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
>
> Fix looks correct.

Thanks for the confirmation.  So hopefully one of these trees will be
merged by Linus soon an this can be fixed up in the other.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Sep_2009_16_53_09_+1000_9zeGCNmYicgvW.+V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqvOdUACgkQjjKRsyhoI8ypQwCghZr31qeK003FazBbXcWbQvU9
YrgAnAxRBQJR+IkKOnuXqoR30eNbE3da
=S44f
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Sep_2009_16_53_09_+1000_9zeGCNmYicgvW.+V--
