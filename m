Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbZKXFmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbZKXFmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 00:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbZKXFmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 00:42:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35269 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbZKXFmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 00:42:17 -0500
Date: Tue, 24 Nov 2009 16:42:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: mfd tree build warning
Message-Id: <20091124164219.c5d54461.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_Nov_2009_16_42_19_+1100_hESVTDJL8X.Mjlkr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Nov_2009_16_42_19_+1100_hESVTDJL8X.Mjlkr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

I have been getting these warnings from the x86_64 allmodconfig build for
a long time:

drivers/mfd/wm8350-regmap.c:3177:2: warning: #warning No WM8350 config mode=
s supported - select at least one of the
drivers/mfd/wm8350-regmap.c:3178:2: warning: #warning MFD_WM8350_CONFIG_MOD=
E_n options from the board driver.

This may not be a problem, I just thought I should let you know.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Nov_2009_16_42_19_+1100_hESVTDJL8X.Mjlkr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksLcjsACgkQjjKRsyhoI8xMywCeL0QpNTk0gSQktpfeoNKkljFr
ZPsAn1Co8EgtdkFBYee7WgxbtrFy9MDv
=7/1S
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Nov_2009_16_42_19_+1100_hESVTDJL8X.Mjlkr--
