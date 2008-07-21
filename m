Return-Path: <linux-kernel-owner+w=401wt.eu-S932307AbYGUDv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbYGUDv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 23:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759610AbYGUDvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 23:51:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34005 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759046AbYGUDvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 23:51:20 -0400
Date: Mon, 21 Jul 2008 13:51:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: please hold off 2.6.28 stuff
Message-Id: <20080721135108.d4ca4be5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__21_Jul_2008_13_51_08_+1000_WY8xHI_DZj7tqGWk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Jul_2008_13_51_08_+1000_WY8xHI_DZj7tqGWk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Andrew mentioned this and I just thought I would reinforce the message:

Please do not put 2.6.28 code into linux-next until at least after -rc1.
This will help Andrew's sanity :-)

So the day that -RC1 is released, I would like for linux-next to be
just about empty wrt Linus' tree.  (Apart from bug fixes and late merges,
of course).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_Jul_2008_13_51_08_+1000_WY8xHI_DZj7tqGWk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiEB6wACgkQjjKRsyhoI8yB5ACeNw1F7Tsl8Cq5FBQmm95au37D
PpgAnjJUTlCXa0od1SyUtIvQ3F783bql
=O1Sn
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jul_2008_13_51_08_+1000_WY8xHI_DZj7tqGWk--
