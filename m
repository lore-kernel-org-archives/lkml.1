Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbZJLDYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbZJLDYP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 23:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZJLDYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 23:24:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56268 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbZJLDYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 23:24:14 -0400
Date: Mon, 12 Oct 2009 14:23:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: linux-next: manual merge of the i7core_edac tree with Linus' tree
Message-Id: <20091012142328.710881fe.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__12_Oct_2009_14_23_28_+1100_Mi7unwoFi5_.c9kr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Oct_2009_14_23_28_+1100_Mi7unwoFi5_.c9kr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the i7core_edac tree got a conflict in
arch/x86/kernel/cpu/mcheck/mce.c between commit
f436f8bb73138bc74eb1c6527723e00988ad8a8a ("x86: EDAC: MCE: Fix MCE
decoding callback logic") from Linus' tree and commit
699a7dbe1ffdf4b25c1475e45590b181c3e23087 ("edac_mce: Add an interface
driver to report mce errors via edac") from the i7core_edac tree.

I don't know how to resolve these two commits so I have dropped the
i7core_edac tree for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__12_Oct_2009_14_23_28_+1100_Mi7unwoFi5_.c9kr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrSoTAACgkQjjKRsyhoI8yOwgCbB20h2D713gdYzbxRdYHo0ltJ
F8oAn2myOfg18nSGSZrSVgtcNOmBXJHs
=0fTt
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Oct_2009_14_23_28_+1100_Mi7unwoFi5_.c9kr--
