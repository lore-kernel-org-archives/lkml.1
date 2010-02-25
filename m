Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482Ab0BYXLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:11:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48295 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934453Ab0BYXLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:11:09 -0500
Date: Fri, 26 Feb 2010 10:11:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20100226101101.136af742.sfr@canb.auug.org.au>
In-Reply-To: <20100225074757.GN1025@kernel.dk>
References: <20100225141022.c5b3b7ce.sfr@canb.auug.org.au>
	<20100225074757.GN1025@kernel.dk>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Feb_2010_10_11_01_+1100_=rTTqY6SNipC+2T="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Feb_2010_10_11_01_+1100_=rTTqY6SNipC+2T=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Thu, 25 Feb 2010 08:47:57 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
>
> I was, unfortunately I forgot to resolve the conflict yesterday. Your
> fix confuses me a bit - I was expecting the first hunk, but what is the
> second hunk doing? Conceptually good though, perhaps there are more
> conflicts than I was expecting :-)

The second hunk was not part of the conflict, but "git diff" gives us more
than just the conflicted bit of the file.

> I'll update here as well so it disappears next time you pull.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Feb_2010_10_11_01_+1100_=rTTqY6SNipC+2T=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuHA4UACgkQjjKRsyhoI8wqMQCfWDdZKat8w83QhL2lKMSUAaH+
fCQAoI538OmFRIFPtIaulSWtkXHPvR63
=4tSU
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Feb_2010_10_11_01_+1100_=rTTqY6SNipC+2T=--
