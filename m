Return-Path: <linux-kernel-owner+w=401wt.eu-S1764307AbYEGQQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764307AbYEGQQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYEGQQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:16:36 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:11782 "EHLO
	outbound6-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754057AbYEGQQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:16:34 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K0IAJA-04-HBN-01
Date: Wed, 7 May 2008 10:18:33 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: linux-kernel@vger.kernel.org
Cc: linux-geode@lists.infradead.org, akpm@linux-foundation.org
Subject: [PATCH] Update Geode mailing list in MAINTAINERS
Message-ID: <20080507161833.GA1217@cosmic.amd.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 07 May 2008 16:16:28.0983 (UTC) FILETIME=[B4AE5470:01C8B05D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The AMD Geode linux list has a new home (thank goodness).  This 
patch updates MAINTAINERS accordingly.

Jordan
-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

--Qxx1br4bt0+wmkIi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="fix-maintainers.patch"

[PATCH] Update Geode mailing list in MAINTAINERS

From: Jordan Crouse <jordan.crouse@amd.com>

Update the Geode list location in the MAINTAINERS file.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
---

 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index abe2787..b5cb603 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -367,12 +367,12 @@ S:	Maintained for 2.4; PCI support for 2.6.
 AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
 P:	Thomas Dahlmann
 M:	thomas.dahlmann@amd.com
-L:	info-linux@geode.amd.com	(subscribers-only)
+L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
 P:	Jordan Crouse
-L:	info-linux@geode.amd.com	(subscribers-only)
+L:	linux-geode@lists.infradead.org (moderated for non-subscribers)	
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
 

--Qxx1br4bt0+wmkIi--

