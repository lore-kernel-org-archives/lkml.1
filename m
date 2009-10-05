Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbZJEHyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbZJEHyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbZJEHyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:54:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35765 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758618AbZJEHyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:54:24 -0400
Date: Mon, 5 Oct 2009 18:53:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com
Subject: Re: linux-next: block/drbd tree build failure
Message-Id: <20091005185340.742f6abc.sfr@canb.auug.org.au>
In-Reply-To: <20091005072929.GS26573@kernel.dk>
References: <20091005143552.977a2d4d.sfr@canb.auug.org.au>
	<20091005063138.GO26573@kernel.dk>
	<20091005182103.0a391d15.sfr@canb.auug.org.au>
	<20091005072929.GS26573@kernel.dk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__5_Oct_2009_18_53_40_+1100_KD8ZHYxLOAnP8AEo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Oct_2009_18_53_40_+1100_KD8ZHYxLOAnP8AEo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Mon, 5 Oct 2009 09:29:29 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
>
> Ah indeed, thanks. I'll put a fixup patch in place.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__5_Oct_2009_18_53_40_+1100_KD8ZHYxLOAnP8AEo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrJpgQACgkQjjKRsyhoI8xShgCgtCgEt3cHpNHrIB6MQvPbZ8jg
GG4An2jQUS4YnahT+l3BuBz3zDZ1Hy/Q
=R712
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Oct_2009_18_53_40_+1100_KD8ZHYxLOAnP8AEo--
