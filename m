Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbXIZKCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbXIZKCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 06:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbXIZKCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 06:02:43 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:37468 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbXIZKCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 06:02:42 -0400
Date: Wed, 26 Sep 2007 01:54:55 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix wrong filename reference in drivers-testing.txt
Message-ID: <20070926005455.GA21953@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/Documentation/power/drivers-testing.txt b/Documentation/power/drivers-testing.txt
index 33016c2..e4bdcae 100644
--- a/Documentation/power/drivers-testing.txt
+++ b/Documentation/power/drivers-testing.txt
@@ -14,8 +14,8 @@ the machine's BIOS.
 Of course, for this purpose the test system has to be known to suspend and
 resume without the driver being tested.  Thus, if possible, you should first
 resolve all suspend/resume-related problems in the test system before you start
-testing the new driver.  Please see Documents/power/basic-pm-debugging.txt for
-more information about the debugging of suspend/resume functionality.
+testing the new driver.  Please see Documentation/power/basic-pm-debugging.txt
+for more information about the debugging of suspend/resume functionality.
 
 2. Testing the driver
 
