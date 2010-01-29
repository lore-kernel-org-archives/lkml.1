Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451Ab0A2AN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0A2AN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 19:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873Ab0A2ANx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 19:13:53 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39092 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab0A2ANs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 19:13:48 -0500
Date: Fri, 29 Jan 2010 11:13:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the davinci tree with the arm tree
Message-Id: <20100129111342.203358d9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Jan_2010_11_13_42_+1100_.=Lo5Tqwm.Kh3Q6o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jan_2010_11_13_42_+1100_.=Lo5Tqwm.Kh3Q6o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kevin,

Today's linux-next merge of the davinci tree got a conflict in
arch/arm/mach-bcmring/core.c between commit
dd84ce18c8f522d26aef6e9e9c05c32485b667a7 ("ARM: Consolidate
clks_register() and similar") from the arm tree and commit
25c692215f5dfc4992b11c4fb57538d1139d6636 ("Consolidate clks_register()
and similar") from the davinci tree.

The davinci tree version has a typo (ARRAY_SIEZ v. ARRAY_SIZE) so I used
the arm tree version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__29_Jan_2010_11_13_42_+1100_.=Lo5Tqwm.Kh3Q6o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktiKDYACgkQjjKRsyhoI8wVUgCgwIk7mnhk9fqJLSo+B0YSGebG
9S0An1gIiclShYebdgyxK7/pD3jZPWlz
=rQqn
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jan_2010_11_13_42_+1100_.=Lo5Tqwm.Kh3Q6o--
