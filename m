Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbXG2EuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbXG2EuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 00:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXG2Ety
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 00:49:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48386 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbXG2Etx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 00:49:53 -0400
Date: Sun, 29 Jul 2007 14:49:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/i386/kernel/apm.c: apm_init() warning fix
Message-Id: <20070729144943.83f0c433.sfr@canb.auug.org.au>
In-Reply-To: <20070729024918.GA19311@kernel.sg>
References: <20070729024918.GA19311@kernel.sg>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__29_Jul_2007_14_49_43_+1000_huNj_d4ymytC53je"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__29_Jul_2007_14_49_43_+1000_huNj_d4ymytC53je
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 29 Jul 2007 10:49:18 +0800 Eugene Teo <eugeneteo@kernel.sg> wrote:
>
> arch/i386/kernel/apm.c: In function 'apm_init':
> arch/i386/kernel/apm.c:2240: warning: format '%lx' expects type 'long
> 	unsigned int', but argument 3 has type 'u32'
>=20
> apm_info.bios.offset is of type 'u32'.
>=20
> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__29_Jul_2007_14_49_43_+1000_huNj_d4ymytC53je
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGrBxuTgG2atn1QN8RAqbJAJsH83i1BkW8Jwy2mmC26WSnKNsYpACbByLh
rksFF07bu8jvP4O+gSe6v24=
=ub9N
-----END PGP SIGNATURE-----

--Signature=_Sun__29_Jul_2007_14_49_43_+1000_huNj_d4ymytC53je--
