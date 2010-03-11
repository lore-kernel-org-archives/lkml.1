Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0CKES3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 23:18:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45739 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab0CKES1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 23:18:27 -0500
Date: Thu, 11 Mar 2010 15:18:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>, Thomas Weber <weber@corscience.de>
Subject: linux-next: manual merge of the omap_dss2 tree with the omap tree
Message-Id: <20100311151819.7c370c92.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Mar_2010_15_18_19_+1100_pY2.nC/hveDQmngF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Mar_2010_15_18_19_+1100_pY2.nC/hveDQmngF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
drivers/video/omap2/vram.c between commit
4ff6baf45cd23593592e5786ccd607bdc8785f4c ("omap: Fix compile for
early_param and omap_smc1") from the omap tree and commit
5c1f96f4cffbdde9e194f3ae5373953f3fa12836 ("OMAP: DSS2: VRAM: Fix
early_param for vram") from the omap_dss2 tree.

Just two versions of the same fix to omap_vram_early_vram().  I used the
omap tree version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Mar_2010_15_18_19_+1100_pY2.nC/hveDQmngF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEARECAAYFAkuYbwsACgkQjjKRsyhoI8yWhwCXRzQdMayFxDxN5heR8zK2MfN9
jgCgt3kZa9NYAecys9MrHnelk3G+3jM=
=qiN5
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Mar_2010_15_18_19_+1100_pY2.nC/hveDQmngF--
