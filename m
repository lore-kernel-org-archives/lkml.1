Return-Path: <linux-kernel-owner+w=401wt.eu-S1751590AbYJSNbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbYJSNbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 09:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYJSNbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 09:31:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48285 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbYJSNbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 09:31:39 -0400
Date: Mon, 20 Oct 2008 00:31:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next current contents
Message-Id: <20081020003131.e077b234.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__20_Oct_2008_00_31_31_+1100_EQ/d9nYprV.hTlQi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Oct_2008_00_31_31_+1100_EQ/d9nYprV.hTlQi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Andrew has reminded me, so I will remind you all:  I do not want any
2.6.29 stuff in linux-next until after 2.6.28-rc1 (at least).  What is in
linux-next now should all be destined for the current merge window and so
should migrate out of linux-next during this next week.

My hope is that when Linus releases -rc1 thee will be very little in
linux-next - the exceptions being bug/regression fixes (and maybe a
couple of things that need to merge late due to dependencies).

If you have already added 2.6.29 things to your tree, please remove it
for now.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__20_Oct_2008_00_31_31_+1100_EQ/d9nYprV.hTlQi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj7NrMACgkQjjKRsyhoI8w2RwCgqf5kMWTx/O+04JE5/G2WoKXe
coIAoKtLMTurPVroXEJokvJHWarCRvGb
=f49W
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Oct_2008_00_31_31_+1100_EQ/d9nYprV.hTlQi--
