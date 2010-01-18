Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889Ab0ARC4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0ARC4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712Ab0ARC4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:56:30 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49622 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab0ARC43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:56:29 -0500
Date: Mon, 18 Jan 2010 13:56:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>
Subject: linux-next: manual merge of the acpi tree with Linus' tree
Message-Id: <20100118135624.011ee13b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jan_2010_13_56_24_+1100_DxNlahbUbqSqoyMo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jan_2010_13_56_24_+1100_DxNlahbUbqSqoyMo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next merge of the acpi tree got a conflict in
drivers/gpu/drm/i915/intel_lvds.c between commit
40f33a92100f4d9b6e85ad642100cfe42d7ff57d ("drm/i915: Add HP
nx9020/SamsungSX20S to ACPI LID quirk list") from Linus' tree and commit
25fbdd0b66c193607ed058662e06d29345766c17 ("drm/i915: Add HP
nx9020/Samsung SX20S to ACPI LID quirk list") from the acpi tree.

Clearly two (slightly different) versions of the same change.  I used the
version from the drm tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jan_2010_13_56_24_+1100_DxNlahbUbqSqoyMo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktTzdgACgkQjjKRsyhoI8yC+gCgk0pHRXt2btlFq2Ad49mW0+f4
12EAoIrKGla77HTKlnj9hQaG0Ve3HRgp
=0U57
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jan_2010_13_56_24_+1100_DxNlahbUbqSqoyMo--
