Return-Path: <linux-kernel-owner+w=401wt.eu-S1764755AbYCEH5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764755AbYCEH5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbYCEH5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:57:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57590 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945AbYCEH5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:57:41 -0500
Date: Wed, 5 Mar 2008 18:57:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 4
Message-Id: <20080305185730.fa4389a5.sfr@canb.auug.org.au>
In-Reply-To: <47CDB8BB.9020909@s5r6.in-berlin.de>
References: <20080304223947.375be10b.sfr@canb.auug.org.au>
	<47CDB8BB.9020909@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__5_Mar_2008_18_57_30_+1100_53H2blE3Qg+J_ks_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Mar_2008_18_57_30_+1100_53H2blE3Qg+J_ks_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefan, Sam,

On Tue, 04 Mar 2008 22:01:47 +0100 Stefan Richter <stefanr@s5r6.in-berlin.d=
e> wrote:
>
> One of them is tests.git's lib/Kconfig.debug.  linux1394-2.6.git's=20
> commit 523a65f1a7a339e528ca6d6d808516fe195fde03 apparently is the one=20
> causing it.
>=20
> Stephen, should one of me and Sam adjust his -next branch?  (This kind=20
> of conflict will be trivially avoided in the merge window; so resolving=20
> it now would mainly mean one manual(?) step less for Stephen.)

I can live with it for a while.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__5_Mar_2008_18_57_30_+1100_53H2blE3Qg+J_ks_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHzlJyTgG2atn1QN8RAuSlAJ9rdSJV2ulUO8Ye8ozbY8H/JC84dgCggxv5
oFsxMxJ44AEkgc6tMQHEfCo=
=Rwvt
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Mar_2008_18_57_30_+1100_53H2blE3Qg+J_ks_--
