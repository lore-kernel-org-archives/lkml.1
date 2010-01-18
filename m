Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729Ab0ARHyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0ARHyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439Ab0ARHyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:54:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42921 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091Ab0ARHx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:53:57 -0500
Date: Mon, 18 Jan 2010 18:53:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wu Zhangjin <wuzhangjin@gmail.com>, Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the staging tree with the mips tree
Message-Id: <20100118185351.3c6b719f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jan_2010_18_53_51_+1100_RZIkvNnVavPhF_BX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jan_2010_18_53_51_+1100_RZIkvNnVavPhF_BX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/sm7xx/smtc2d.c drivers/staging/sm7xx/smtc2d.h between
commit 8cdfa0e5f204ee97d27f742ebd207f4de8ca2984 ("Loongson: Change the
Email address of Wu Zhangjin") from the mips tree and commit
1467bbc532da8c044e57706db232efe616ae5b00 ("staging: sm7xx: remove the
buggy 2D acceleration support") from the staging tree.

I just removed the 2 files (as was done in the staging tree).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jan_2010_18_53_51_+1100_RZIkvNnVavPhF_BX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktUE48ACgkQjjKRsyhoI8zTpwCfee+B7xviNLUnSIpON67Ofl8Y
nPIAoJLx0RFLaOQFIOa2o93qOp388bEe
=+fmK
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jan_2010_18_53_51_+1100_RZIkvNnVavPhF_BX--
