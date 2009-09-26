Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbZIZBCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbZIZBCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 21:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZIZBCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 21:02:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54723 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbZIZBCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 21:02:03 -0400
Date: Sat, 26 Sep 2009 11:01:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Beulich <JBeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the sparc-current tree with Linus' tree
Message-Id: <20090926110158.0fcd2763.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__26_Sep_2009_11_01_58_+1000_esQFDqsmjiMB.Jz/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__26_Sep_2009_11_01_58_+1000_esQFDqsmjiMB.Jz/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next merge of the sparc-current tree got a conflict in
arch/sparc/include/asm/vio.h between commit
8c87df457cb58fe75b9b893007917cf8095660a0 ("BUILD_BUG_ON(): fix it and a
couple of bogus uses of it") from Linus' tree and commit
87ba00515657eede6077fa195ca6592b98cc31e3 ("sparc64: vio: Kill BUILD_BUG_ON
() in vio_dring_avail()") from the sparc-current tree.

I just used the sparc-current version for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__26_Sep_2009_11_01_58_+1000_esQFDqsmjiMB.Jz/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkq9aAYACgkQjjKRsyhoI8zaKQCfZtITbifdPgkvUpxhVdrGNEfr
m8QAniYlQAiM4h3mxAW/o2UYwkecdWl1
=YG2N
-----END PGP SIGNATURE-----

--Signature=_Sat__26_Sep_2009_11_01_58_+1000_esQFDqsmjiMB.Jz/--
