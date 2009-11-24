Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbZKXDLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbZKXDLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 22:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757879AbZKXDLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 22:11:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58108 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757602AbZKXDLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 22:11:41 -0500
Date: Tue, 24 Nov 2009 14:11:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the wireless tree with the
 wireless-current tree
Message-Id: <20091124141141.5b6d3a8d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_Nov_2009_14_11_41_+1100_fWDQk=cAr=Nvns1W"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Nov_2009_14_11_41_+1100_fWDQk=cAr=Nvns1W
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/ath/ath9k/main.c between commit
54ab040d24904d1fa2c0a6a27936b7c56a4efb24 ("ath9k: set ps_default as
false") from the wireless-current tree and commit
18b6c9a2213d3b6e0212e8b225abf95f7564206a ("ath9k: set ps_default as
false") from the wireless tree.

The commit message of the latter made me use just its version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Nov_2009_14_11_41_+1100_fWDQk=cAr=Nvns1W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksLTu0ACgkQjjKRsyhoI8x8AACfWTR3pTuqK1Q4wEEjFjZtxKuo
MTUAn0nuH9aQSc2r+myZ6Ss8bA6trxnI
=GVQ+
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Nov_2009_14_11_41_+1100_fWDQk=cAr=Nvns1W--
