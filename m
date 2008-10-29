Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbYJ2Wig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbYJ2Wig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbYJ2WiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:38:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59335 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336AbYJ2WiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:38:15 -0400
Date: Thu, 30 Oct 2008 09:38:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: fix uninitialized variable in iscsi
Message-Id: <20081030093807.cb564760.sfr@canb.auug.org.au>
In-Reply-To: <490884CC.9060106@cs.wisc.edu>
References: <20081029170359.70682e02.sfr@canb.auug.org.au>
	<490884CC.9060106@cs.wisc.edu>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Oct_2008_09_38_07_+1100_B2xWYG.NJqkv3_Ff"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Oct_2008_09_38_07_+1100_B2xWYG.NJqkv3_Ff
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Wed, 29 Oct 2008 10:44:12 -0500 Mike Christie <michaelc@cs.wisc.edu> wro=
te:
>
> I have a patch for this from Benny Halevy already.

OK, good.

BTW, the tree listed in the maintainers file "git
kernel.org:/pub/scm/linux/kernel/mnc/linux-2.6-iscsi.git" doesn't work ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Oct_2008_09_38_07_+1100_B2xWYG.NJqkv3_Ff
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkI5c8ACgkQjjKRsyhoI8zl8gCeNx6CGvZt3sTHAZBfuUjJUQK9
j/0An1ISky1TorxTemT5WtSRUa72BWB2
=K24S
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Oct_2008_09_38_07_+1100_B2xWYG.NJqkv3_Ff--
