Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbZKWXxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbZKWXxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757492AbZKWXxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:53:03 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48126 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829AbZKWXxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:53:01 -0500
Date: Tue, 24 Nov 2009 10:53:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: failed to fetch the mips tree
Message-Id: <20091124105303.512479aa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_Nov_2009_10_53_03_+1100_q2.3EmxB3cfI6JNI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Nov_2009_10_53_03_+1100_q2.3EmxB3cfI6JNI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

Today's fetch of the mips tree got this error:

git.linux-mips.org[0: 78.24.191.183]: errno=3DConnection refused
fatal: unable to connect a socket (Connection refused)

I will use the version from next-20091123 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Nov_2009_10_53_03_+1100_q2.3EmxB3cfI6JNI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksLIF8ACgkQjjKRsyhoI8y/IACff+jsQdXtOf/jo7W8Bv59jHhv
dqsAnRhEC0V82IaATKoQfsrMAp6tQ2Ew
=yg4j
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Nov_2009_10_53_03_+1100_q2.3EmxB3cfI6JNI--
