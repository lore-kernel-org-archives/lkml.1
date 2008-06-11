Return-Path: <linux-kernel-owner+w=401wt.eu-S1758900AbYFKXK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900AbYFKXK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 19:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYFKXKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 19:10:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36797 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbYFKXKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 19:10:12 -0400
Date: Thu, 12 Jun 2008 09:10:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 11 - on ia64
Message-Id: <20080612091003.775bc671.sfr@canb.auug.org.au>
In-Reply-To: <484FE1EE.9020201@linux.vnet.ibm.com>
References: <20080611193840.08a35b14.sfr@canb.auug.org.au>
	<484FE1EE.9020201@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Jun_2008_09_10_03_+1000_qTA4nMRA2oeAkxDd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Jun_2008_09_10_03_+1000_qTA4nMRA2oeAkxDd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

One for you?

On Wed, 11 Jun 2008 20:02:14 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>
> The next-20080611 kernel build fails on ia64 machine
>=20
>   AR      arch/ia64/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux
>   LD      vmlinux
> ld: .tmp_kallsyms.o: linking constant-gp files with non-constant-gp files
> ld: failed to merge target specific data of file .tmp_kallsyms.o
> make: *** [vmlinux] Error 1
>=20
> --=20
> Thanks & Regards,
> Kamalesh Babulal,
> Linux Technology Center,
> IBM, ISTL.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Jun_2008_09_10_03_+1000_qTA4nMRA2oeAkxDd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhQW0sACgkQTgG2atn1QN8gsQCfWLhWhcbULR7y7qW850v7dMzZ
jeYAnA00FEZEMT0vMX5xFXUVrgXZwYnJ
=Tttp
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Jun_2008_09_10_03_+1000_qTA4nMRA2oeAkxDd--
