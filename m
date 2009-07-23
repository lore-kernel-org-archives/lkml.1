Return-Path: <linux-kernel-owner+w=401wt.eu-S1752486AbZGWBVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbZGWBVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 21:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZGWBVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 21:21:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48650 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbZGWBVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 21:21:17 -0400
Date: Thu, 23 Jul 2009 11:21:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chaithrika U S <chaithrika@ti.com>,
       Pavel Kiryukhin <pkiryukhin@ru.mvista.com>,
       Naresh Medisetty <naresh@ti.com>, Steve Chen <schen@mvista.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>
Subject: linux-next: manual merge of the sound tree with the davinci tree
Message-Id: <20090723112110.e42430e9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Jul_2009_11_21_10_+1000_mC3rUaRrIR40MFl6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Jul_2009_11_21_10_+1000_mC3rUaRrIR40MFl6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next merge of the sound tree got a conflict in
sound/soc/davinci/davinci-evm.c between commit
95d0d986d09ac25a5b9f2bf28f289ab0823e86d5 ("davinci: EDMA: multiple CCs,
channel mapping and API changes") from the davinci tree and commit
04f80f5c486b39446af44e218dba90ec210d61ca ("ASoC: Add machine driver
support for DM646x") from the sound tree.

The latter removes the code modified by the former.  I have just used the
latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Jul_2009_11_21_10_+1000_mC3rUaRrIR40MFl6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpnuwYACgkQjjKRsyhoI8yJDwCcC6q4QwdEHSYj8ibh8Ln2FcHY
1TQAmwdT3TjdtEx+g9vsVx2+2LK6rx1n
=avKv
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Jul_2009_11_21_10_+1000_mC3rUaRrIR40MFl6--
