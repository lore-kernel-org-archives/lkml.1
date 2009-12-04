Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbZLDWtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbZLDWtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZLDWtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:49:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50853 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbZLDWte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:49:34 -0500
Date: Sat, 5 Dec 2009 09:49:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: linux-next: block tree build failure
Message-Id: <20091205094934.eefdddf4.sfr@canb.auug.org.au>
In-Reply-To: <20091204135422.GZ8742@kernel.dk>
References: <20091204143612.f30db275.sfr@canb.auug.org.au>
	<20091204074341.GH8742@kernel.dk>
	<20091204135422.GZ8742@kernel.dk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__5_Dec_2009_09_49_34_+1100_0qiK8Z_vqwZ+og0X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__5_Dec_2009_09_49_34_+1100_0qiK8Z_vqwZ+og0X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Fri, 4 Dec 2009 14:54:22 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
>
> I pushed out the quick fix, just disallowing cfq=3Dm and blk cgroup in
> Kconfig. So it should work now.

Great, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__5_Dec_2009_09_49_34_+1100_0qiK8Z_vqwZ+og0X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksZkf4ACgkQjjKRsyhoI8xlcQCgkdn51TtvHLKUv019VIlGrUIH
RbEAnjV/zNdaKfxcFEN8zp3cTnt+oj/O
=3V3F
-----END PGP SIGNATURE-----

--Signature=_Sat__5_Dec_2009_09_49_34_+1100_0qiK8Z_vqwZ+og0X--
