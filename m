Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbYEWBmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbYEWBmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 21:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYEWBmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 21:42:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37815 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbYEWBl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 21:41:59 -0400
Date: Fri, 23 May 2008 11:41:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulus@samba.org
Cc: ppc-dev <linuxppc-dev@ozlabs.org>, axboe@kernel.dk,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] [POWERPC] iSeries: remove unused mail address
Message-Id: <20080523114146.7f96ca09.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_May_2008_11_41_46_+1000_gGIs4G2SIQALW4Gr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_May_2008_11_41_46_+1000_gGIs4G2SIQALW4Gr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I don't use my IBM email address normally and people can find me in
CREDITS.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/block/viodasd.c |    2 +-
 drivers/cdrom/viocd.c   |    2 +-
 drivers/char/viocons.c  |    2 +-
 drivers/char/viotape.c  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

Jens, I assume that this is trivial enough that it can be sent via the
powerpc tree.

diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
index ebfe038..f1c8feb 100644
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -3,7 +3,7 @@
  *  Authors: Dave Boutcher <boutcher@us.ibm.com>
  *           Ryan Arnold <ryanarn@us.ibm.com>
  *           Colin Devilbiss <devilbis@us.ibm.com>
- *           Stephen Rothwell <sfr@au1.ibm.com>
+ *           Stephen Rothwell
  *
  * (C) Copyright 2000-2004 IBM Corporation
  *
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index 5245a4a..9d0dfe6 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -6,7 +6,7 @@
  *  Authors: Dave Boutcher <boutcher@us.ibm.com>
  *           Ryan Arnold <ryanarn@us.ibm.com>
  *           Colin Devilbiss <devilbis@us.ibm.com>
- *           Stephen Rothwell <sfr@au1.ibm.com>
+ *           Stephen Rothwell
  *
  * (C) Copyright 2000-2004 IBM Corporation
  *
diff --git a/drivers/char/viocons.c b/drivers/char/viocons.c
index 3d3e1c2..65fb848 100644
--- a/drivers/char/viocons.c
+++ b/drivers/char/viocons.c
@@ -7,7 +7,7 @@
  *  Authors: Dave Boutcher <boutcher@us.ibm.com>
  *           Ryan Arnold <ryanarn@us.ibm.com>
  *           Colin Devilbiss <devilbis@us.ibm.com>
- *           Stephen Rothwell <sfr@au1.ibm.com>
+ *           Stephen Rothwell
  *
  * (C) Copyright 2000, 2001, 2002, 2003, 2004 IBM Corporation
  *
diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index 58aad63..c39ddaf 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -6,7 +6,7 @@
  *  Authors: Dave Boutcher <boutcher@us.ibm.com>
  *           Ryan Arnold <ryanarn@us.ibm.com>
  *           Colin Devilbiss <devilbis@us.ibm.com>
- *           Stephen Rothwell <sfr@au1.ibm.com>
+ *           Stephen Rothwell
  *
  * (C) Copyright 2000-2004 IBM Corporation
  *
--=20
1.5.5.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__23_May_2008_11_41_46_+1000_gGIs4G2SIQALW4Gr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINiDeTgG2atn1QN8RAi/yAKCPvAIV6N8hB4Qa84dRfyTkQUmmBQCcC2QL
9GSe2Yvt1jL5F5qxRSuLWtk=
=CHux
-----END PGP SIGNATURE-----

--Signature=_Fri__23_May_2008_11_41_46_+1000_gGIs4G2SIQALW4Gr--
