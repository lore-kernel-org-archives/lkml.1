Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbZG3Aow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbZG3Aow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 20:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbZG3Aov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 20:44:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39304 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbZG3Aov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 20:44:51 -0400
Date: Thu, 30 Jul 2009 10:44:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: i2c series import failure
Message-Id: <20090730104443.49df80a0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Jul_2009_10_44_43_+1000_8I5/Q2Wh65RAurmA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jul_2009_10_44_43_+1000_8I5/Q2Wh65RAurmA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

Today's linux-next import of the i2c series failed like this:

i2c-tsl2550-simpify-IO.patch
error: patch failed: drivers/i2c/chips/tsl2550.c:24
error: drivers/i2c/chips/tsl2550.c: patch does not apply

I will use the series from yesterday.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Jul_2009_10_44_43_+1000_8I5/Q2Wh65RAurmA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpw7PsACgkQjjKRsyhoI8zm8wCfTXPrfFo0oTWV8i41cwjb1Yme
m+kAoIAjvr3+zt0DIb5G20XhfvYLqDNj
=HUbg
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jul_2009_10_44_43_+1000_8I5/Q2Wh65RAurmA--
