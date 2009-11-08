Return-Path: <linux-kernel-owner+w=401wt.eu-S1751951AbZKHXaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbZKHXaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 18:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZKHXaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 18:30:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54605 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZKHXaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 18:30:18 -0500
Date: Mon, 9 Nov 2009 10:30:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: limits tree fetch failure
Message-Id: <20091109103017.6099f588.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Nov_2009_10_30_17_+1100_MHp0RoHFRrGQ0/Pg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Nov_2009_10_30_17_+1100_MHp0RoHFRrGQ0/Pg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next fetch of the limits tree produced this error:

decibel.fi.muni.cz[0: 147.251.50.163]: errno=3DConnection timed out
fatal: unable to connect a socket (Connection timed out)

I will use the version of the tree from next-20091106.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Nov_2009_10_30_17_+1100_MHp0RoHFRrGQ0/Pg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr3VIkACgkQjjKRsyhoI8xbiQCZATCwInQUKOLAjLJvLBgIn0ty
i7cAoIsPL8JqIVnqaNGVZ18+andf8SCV
=CgtD
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Nov_2009_10_30_17_+1100_MHp0RoHFRrGQ0/Pg--
