Return-Path: <linux-kernel-owner+w=401wt.eu-S965182AbZLHARW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965182AbZLHARW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964890AbZLHARV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:17:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55058 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935584AbZLHARU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:17:20 -0500
Date: Tue, 8 Dec 2009 11:17:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the samsung tree
Message-Id: <20091208111722.2e8d9527.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_Dec_2009_11_17_22_+1100_2pW2R9.8ZAE/68q1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Dec_2009_11_17_22_+1100_2pW2R9.8ZAE/68q1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

In today's linux-next merge of the samsung tree I noticed that the file
arch/arm/plat-s3c/dev-hsmmc2.c actually has some merge conflict artifacts
in it.

I fixed them up (just by using the version from the arm tree) but it
would be good if this could be fixed in your tree as well (I notice that
Russell has already merged a (presumable) correct version of these files).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_Dec_2009_11_17_22_+1100_2pW2R9.8ZAE/68q1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksdmxIACgkQjjKRsyhoI8yriQCeMXRHL3ytHBSqDdgxTTa+MqNu
Q2oAoIpkAnQhI2kek260pMQ41DbzySan
=mOOe
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Dec_2009_11_17_22_+1100_2pW2R9.8ZAE/68q1--
