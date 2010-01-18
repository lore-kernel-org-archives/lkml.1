Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410Ab0AREOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0AREOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 23:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831Ab0AREOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 23:14:15 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55152 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab0AREOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 23:14:08 -0500
Date: Mon, 18 Jan 2010 15:14:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: origin tree build warning
Message-Id: <20100118151401.dd8a9ef2.sfr@canb.auug.org.au>
In-Reply-To: <20100118150501.f6aa79e3.sfr@canb.auug.org.au>
References: <20100118150501.f6aa79e3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jan_2010_15_14_01_+1100_1FmEL=iJovHphOCJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jan_2010_15_14_01_+1100_1FmEL=iJovHphOCJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 18 Jan 2010 15:05:01 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> It actually looks like commit c29af9636 ("sysdev: Pass attribute in
> sysdev_class attributes show/store") referred to in the changelog for the
> above commit has not yet been applied to Linus' tree?

Commit c29af9636 ("sysdev: Pass attribute in sysdev_class attributes
show/store") does appear in linux-next since next-20100111 (in the
driver-core quilt series - therefore intended for 2.6.34) (it will have a
different SHA1 today)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jan_2010_15_14_01_+1100_1FmEL=iJovHphOCJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktT4AkACgkQjjKRsyhoI8x/KgCePBAAyx95wyzXiyH1FLJo2S07
WbIAn1Nxf4YsQqRg9lxobbSBsfBnKD55
=I895
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jan_2010_15_14_01_+1100_1FmEL=iJovHphOCJ--
