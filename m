Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbZJLXP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbZJLXP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbZJLXPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:15:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43273 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbZJLXPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:15:24 -0400
Date: Tue, 13 Oct 2009 10:14:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: unable to fetch jc_docs tree
Message-Id: <20091013101442.d6e2bd94.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Oct_2009_10_14_42_+1100_fWfHT_WW5ln=JZEf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Oct_2009_10_14_42_+1100_fWfHT_WW5ln=JZEf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jonathan,

Fetching the jc_docs tree today gives me

git.lwn.net[0: 206.168.112.25]: errno=3DConnection timed out
fatal: unable to connect a socket (Connection timed out)

I will use the jc_docs tree from yesterday.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Oct_2009_10_14_42_+1100_fWfHT_WW5ln=JZEf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrTuGIACgkQjjKRsyhoI8wiQwCdFJ1ILok/xMnPYxcv2bP2e1BB
ugsAnRifrEgqaix3nBst4UA7hEd5+8XS
=Y4Kh
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Oct_2009_10_14_42_+1100_fWfHT_WW5ln=JZEf--
