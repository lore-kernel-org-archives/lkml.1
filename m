Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbZFXGb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbZFXGb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZFXGbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:31:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46548 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbZFXGbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:31:47 -0400
Date: Wed, 24 Jun 2009 16:31:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: rr tree build failure
Message-Id: <20090624163144.bc59cb97.sfr@canb.auug.org.au>
In-Reply-To: <200906241254.24945.rusty@rustcorp.com.au>
References: <20090623161416.072b43ba.sfr@canb.auug.org.au>
	<200906241254.24945.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Jun_2009_16_31_44_+1000_+MpSLjQgloM/VqrA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Jun_2009_16_31_44_+1000_+MpSLjQgloM/VqrA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Wed, 24 Jun 2009 12:54:24 +0930 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> Dumb typo + cut & paste.
>=20
> Fixed,

Thanks, I will pick it up tomorrow.  For today, I have reverted
"cpumask:use-mm_cpumask-arm".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Jun_2009_16_31_44_+1000_+MpSLjQgloM/VqrA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpByFAACgkQjjKRsyhoI8xMjgCgvzGHE6fdS79VDqEgvsf4hesf
3RcAnj82LPvnYcVJDCgQbqghWKAoASgL
=qTO/
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Jun_2009_16_31_44_+1000_+MpSLjQgloM/VqrA--
