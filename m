Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbYHEPYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbYHEPYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbYHEPYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:24:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40727 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbYHEPYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:24:07 -0400
Date: Wed, 6 Aug 2008 01:23:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org
Subject: v4l/mips build problem
Message-Id: <20080806012357.55625daf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Aug_2008_01_23_57_+1000_i2JVJ6yLmX47_gw6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Aug_2008_01_23_57_+1000_i2JVJ6yLmX47_gw6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Linus' current tree gets the following error during a mips allmodconfig
build:

drivers/media/video/vino.c:4364: error: implicit declaration of function `v=
ideo_usercopy'

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__6_Aug_2008_01_23_57_+1000_i2JVJ6yLmX47_gw6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEARECAAYFAkiYcI0ACgkQjjKRsyhoI8wamgCgkcSKgbNYkPosFeczVlj/wZ4I
GQsAl3J1/Z+woSBs6uTe8k2rPPfAD+0=
=HFni
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Aug_2008_01_23_57_+1000_i2JVJ6yLmX47_gw6--
