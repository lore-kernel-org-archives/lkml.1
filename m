Return-Path: <linux-kernel-owner+w=401wt.eu-S1752493AbZIIBlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbZIIBlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZIIBlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:41:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37542 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbZIIBlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:41:21 -0400
Date: Wed, 9 Sep 2009 11:41:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: Re: linux-next: async_tx tree build failure
Message-Id: <20090909114116.3f3c7a77.sfr@canb.auug.org.au>
In-Reply-To: <e9c3a7c20909081835t3cafea3cmb518f83ef12d3599@mail.gmail.com>
References: <20090907130831.c0180edd.sfr@canb.auug.org.au>
	<e9c3a7c20909081835t3cafea3cmb518f83ef12d3599@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Sep_2009_11_41_16_+1000_zlxLek5c/X.pj9E5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Sep_2009_11_41_16_+1000_zlxLek5c/X.pj9E5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Tue, 8 Sep 2009 18:35:12 -0700 Dan Williams <dan.j.williams@intel.com> w=
rote:
>
> Thanks for the report, I have pushed out a fix for this and some other
> fallout from adding CONFIG_I7300_IDLE=3Dy to my build tests.

Thanks, I will include that update today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Sep_2009_11_41_16_+1000_zlxLek5c/X.pj9E5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqnB7wACgkQjjKRsyhoI8zz5gCgrrpmW3opqyaoJb5gYsemjsZF
OLcAnjcuGqoT1ZZTR6NZcRwIpvNfwJ2r
=BLxI
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Sep_2009_11_41_16_+1000_zlxLek5c/X.pj9E5--
