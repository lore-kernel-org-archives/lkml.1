Return-Path: <linux-kernel-owner+w=401wt.eu-S965486AbZLIEGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965486AbZLIEGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 23:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbZLIEGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 23:06:30 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48936 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771AbZLIEGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 23:06:30 -0500
Date: Wed, 9 Dec 2009 15:06:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20091209150627.e501174a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Dec_2009_15_06_27_+1100_1_eh5FQB_TlX281m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Dec_2009_15_06_27_+1100_1_eh5FQB_TlX281m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got conflicts in
arch/x86/include/asm/x86_init.h and arch/x86/kernel/x86_init.c between a
merge in Linus' tree and a merge in the tip tree.

Two fields of a structure just ended up in a different order after the
two merges.  I used the version from Linus' tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Dec_2009_15_06_27_+1100_1_eh5FQB_TlX281m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksfIkMACgkQjjKRsyhoI8yPOACeOr6Jv2WDdi1ZZ7rgGTW2o9a3
ppUAniMab64+KqoT8Grdijd42GBX8PsB
=qup8
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Dec_2009_15_06_27_+1100_1_eh5FQB_TlX281m--
