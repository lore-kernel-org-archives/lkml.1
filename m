Return-Path: <linux-kernel-owner+w=401wt.eu-S965629AbXH0WBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965629AbXH0WBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764906AbXH0WAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:00:11 -0400
Received: from mail0.lsil.com ([147.145.40.20]:61164 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965578AbXH0WAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:00:06 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7E8F5.879230A7"
Subject: RE: Linux-Kernel MAINTAINERS - LSILOGIC MPT FUSION DRIVERS
Date: Mon, 27 Aug 2007 15:59:23 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D709409A0@NAMAIL4.ad.lsil.com>
In-Reply-To: <1188230344.18004.73.camel@localhost>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: Linux-Kernel MAINTAINERS - LSILOGIC MPT FUSION DRIVERS
Thread-Index: AcfowzLmIFJBuCrbQ1yL7aPzagCB/AAMcYBQ
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: "Joe Perches" <joe@perches.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 27 Aug 2007 21:59:23.0931 (UTC) FILETIME=[8761BEB0:01C7E8F5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7E8F5.879230A7
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Monday, August 27, 2007 9:59 AM, Joe Perches wrote:
> On Mon, 2007-08-27 at 09:30 -0600, Moore, Eric wrote:
> > Yes it was changed to DL-MPTFusionLinux@lsi.com.     I had posted a
> > patch about a month back, along with the changes for all the driver
> > sources.=20
>=20
> This is what I have:
>=20
> LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
> P:	Eric Moore
> M:	Eric.Moore@lsi.com
> M:	support@lsi.com
> L:	DL-MPTFusionLinux@lsi.com
> L:	linux-scsi@vger.kernel.org
> W:	http://www.lsilogic.com/support
> S:	Supported
> F:	drivers/message/fusion/
>=20
> > You will notice the sources were updated
> > (driver/message/fusion), I have no idea why MAINTAINERS didn't'.
>=20
> I can't find a patch for MAINTAINERS and DL-MPTFusionLinux
> This commit is just for the sources.
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.g
> it;a=3Dcommitdiff;h=3D16d201016a9f29e0557849907352769c63cef259
>=20

Attached is my patch I posted on June 13, 2007, the same day as the
patch you found.    Here is the weblink:
http://marc.info/?l=3Dlinux-scsi&m=3D118177408121329&w=3D2

Eric

------_=_NextPart_001_01C7E8F5.879230A7
Content-Type: message/rfc822
Content-Transfer-Encoding: 7bit

x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: [PATCH] mpt fusion: update MAINTAINERS
Date: Wed, 13 Jun 2007 16:29:27 -0600
Message-ID: <20070613222927.GA20787@lsil.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: <linux-scsi@vger.kernel.org>,
	<James.Bottomley@SteelEye.com>,
	"DL-MPT Fusion Linux" <DL-MPTFusionLinux@lsi.com>

LSI has a new distribution list for linux support and associated =
inquires.  The previous list at mpt_linux_developer@lsi.com has been =
deleted.  I will continue maintaining this driver, as well as others at =
LSI.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

--- b/MAINTAINERS	2007-06-12 12:21:42.000000000 -0600
+++ a/MAINTAINERS	2007-06-13 14:38:30.000000000 -0600
@@ -2277,11 +2277,10 @@ L:	linux-ntfs-dev@lists.sourceforge.net
 W:	http://www.linux-ntfs.org/content/view/19/37/
 S:	Maintained
=20
-LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
-P:	Eric Moore
-M:	Eric.Moore@lsi.com
+LSI MPT FUSION DRIVERS (FC/SAS/SPI)
+P:	MPT Fusion Linux Team
+M:	DL-MPTFusionLinux@lsi.com
 M:	support@lsi.com
-L:	mpt_linux_developer@lsi.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.lsilogic.com/support
 S:	Supported

------_=_NextPart_001_01C7E8F5.879230A7--
