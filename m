Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYJPQMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYJPQMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYJPQMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:12:14 -0400
Received: from [165.204.77.10] ([165.204.77.10]:27663 "EHLO elemente.amd.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751130AbYJPQMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:12:13 -0400
Message-Id: <200810161700.m9GH02Sp024012@elemente.amd.com>
From: Peter Oruba <peter.oruba@amd.com>
Date: Thu, 16 Oct 2008 18:43:48 +0200
Subject: [PATCH] x86: MAINTAINERS change for AMD microcode patch loader
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
CC: LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed MAINTAINERS entry for AMD microcode patch loader.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 MAINTAINERS |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5d0b8a2..9500e0d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -378,8 +378,9 @@ T:	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
 S:	Supported
 
 AMD MICROCODE UPDATE SUPPORT
-P:      Peter Oruba
-M:      peter.oruba@amd.com
+P:      Andreas Herrmann
+M:      andeas.herrmann3@amd.com
+L:      amd64-microcode@amd64.org
 S:      Supported
 
 AMS (Apple Motion Sensor) DRIVER
-- 
1.5.4.1

