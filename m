Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbZIOHpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbZIOHpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 03:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbZIOHpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 03:45:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43552 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbZIOHpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 03:45:40 -0400
Date: Tue, 15 Sep 2009 17:45:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: linux-next: drbd tree build failure
Message-Id: <20090915174536.f204aade.sfr@canb.auug.org.au>
In-Reply-To: <20090915065721.GQ14984@kernel.dk>
References: <20090915160739.86e85ab3.sfr@canb.auug.org.au>
	<20090915062306.GP14984@kernel.dk>
	<20090915165309.f07381ec.sfr@canb.auug.org.au>
	<20090915065721.GQ14984@kernel.dk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Sep_2009_17_45_36_+1000_1dun0zJg9vLgVBSD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Sep_2009_17_45_36_+1000_1dun0zJg9vLgVBSD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Sep 2009 08:57:21 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
>
> The block one is already merged, so drbd just needs to get fixed up.

Right, that happened after I started this morning.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Sep_2009_17_45_36_+1000_1dun0zJg9vLgVBSD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqvRiAACgkQjjKRsyhoI8zq/wCgmMgQlE41OClWGa8XF4Q/ns73
XrMAn2nUVM3mRj5kGzVUJlVAGpFjqvRq
=Dtyr
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Sep_2009_17_45_36_+1000_1dun0zJg9vLgVBSD--
