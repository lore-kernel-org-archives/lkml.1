Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbZFYDaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbZFYDaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 23:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZFYDaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 23:30:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46437 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbZFYDaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 23:30:07 -0400
Date: Thu, 25 Jun 2009 13:30:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20090625133005.9f521529.sfr@canb.auug.org.au>
In-Reply-To: <20090625131517.d9adc935.sfr@canb.auug.org.au>
References: <20090625131517.d9adc935.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__25_Jun_2009_13_30_05_+1000_LSTCjNN2rYr/x1lH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Jun_2009_13_30_05_+1000_LSTCjNN2rYr/x1lH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Jun 2009 13:15:17 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> I can't see how to easily fix this up, so I have dropped the block tree
> for today (since it only contained 2.6.32 material, right?).

I also dropped the device-mapper tree for today as it was based on the
block tree (and dragged in what I had just dropped) and, in any case, all
its patches have been merged upstream.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__25_Jun_2009_13_30_05_+1000_LSTCjNN2rYr/x1lH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpC7z0ACgkQjjKRsyhoI8wFJwCfdyEMEUILSsMEbp1cPfQeg9Qk
uzIAn18GSkpT36l2LHHs+SdLdTnSbbfs
=S3tf
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Jun_2009_13_30_05_+1000_LSTCjNN2rYr/x1lH--
