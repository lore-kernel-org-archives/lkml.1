Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYBDWWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYBDWWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYBDWVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:21:54 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:33595 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751415AbYBDWVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:21:53 -0500
Subject: Re: 2.6.24-mm1 - build error, AMD MCE using Intel ifdef'd log
	function
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080203171634.58ab668b.akpm@linux-foundation.org>
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TBSMAytQug+4Nd/CMg1o"
Date: Mon, 04 Feb 2008 15:23:50 -0700
Message-Id: <1202163830.6703.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080204/1JM9hD-0000ZG-2t-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TBSMAytQug+4Nd/CMg1o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2008-02-03 at 17:16 -0800, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.=
24-mm1/
>=20
>=20

arch/x86/kernel/built-in.o: In function `amd_smp_thermal_interrupt':
(.text+0xe7c4): undefined reference to `mce_log_therm_throt_event'
make: *** [.tmp_vmlinux1] Error 1

I looked in MAINTAINERS for MCE, MACHINE and CHECK, but didn't spot any
likely entries to CC.
--=20
Zan Lynx <zlynx@acm.org>

--=-TBSMAytQug+4Nd/CMg1o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHp5B2G8fHaOLTWwgRAsyCAJoClmDGGRueZp1F5DMSWauM0j/TmACdH++V
328wgsEQfaVrE26YE11MrNA=
=j7Tg
-----END PGP SIGNATURE-----

--=-TBSMAytQug+4Nd/CMg1o--

