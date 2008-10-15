Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbYJOK7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbYJOK7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbYJOK6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:58:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38126 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbYJOK6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:58:54 -0400
Date: Wed, 15 Oct 2008 21:58:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next tree for Oct 15
Message-Id: <20081015215845.b6bbcb64.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Oct_2008_21_58_45_+1100_dL7IkeQ4GBTAy5cs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Oct_2008_21_58_45_+1100_dL7IkeQ4GBTAy5cs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This tree didn't make it again.  It has just taken way to long,again.  I
will make another attempt tomorrow when, hopefully, some of the things I
have reported today and yesterday will be fixed.

If people are too busy at the moment to fix up their trees, just let me
know and I will drop them (or just take another break until after -rc1).

There are lots of conflicts - most of them are against Linus' tree, so
need looking at when you are preparing your tree for Linus to merge.  If
you ask Linus to merge your tree, at least make the tree I merge the same
(or a superset).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Oct_2008_21_58_45_+1100_dL7IkeQ4GBTAy5cs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj1zOUACgkQjjKRsyhoI8wzEQCfQUjOwCzaECm7dKLwd5OTT0VV
2bMAn2WBEAyboO2izUXbdbejPJXC8qLw
=HldB
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Oct_2008_21_58_45_+1100_dL7IkeQ4GBTAy5cs--
