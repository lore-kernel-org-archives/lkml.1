Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbZGHGoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbZGHGoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbZGHGoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:44:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53413 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbZGHGoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:44:10 -0400
Date: Wed, 8 Jul 2009 16:44:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <sfi-devel@simplefirmware.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: sfi tree build warning
Message-Id: <20090708164400.f2138d79.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Jul_2009_16_44_00_+1000_4HGTPhsx7RULjXkl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Jul_2009_16_44_00_+1000_4HGTPhsx7RULjXkl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

arch/x86/kernel/sfi.c: In function 'sfi_init_memory_map':
arch/x86/kernel/sfi.c:99: warning: cast to pointer from integer of differen=
t size
arch/x86/kernel/sfi.c:100: warning: cast to pointer from integer of differe=
nt size

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__8_Jul_2009_16_44_00_+1000_4HGTPhsx7RULjXkl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpUQDAACgkQjjKRsyhoI8x3xgCeJRk2QFKlfx10xmwTwi1M8oJ6
98MAoJe6cqPo/TkKsX1yv9O4upFPOWNy
=lSWJ
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Jul_2009_16_44_00_+1000_4HGTPhsx7RULjXkl--
