Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbXI0Pvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbXI0Pvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbXI0PvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:51:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232AbXI0PvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:51:11 -0400
Date: Thu, 27 Sep 2007 11:51:09 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Add /dev/oldmem to devices.txt documenation.
Message-ID: <20070927155109.GA21668@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 8de132a..6c46730 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -94,6 +94,8 @@ Your cooperation is appreciated.
 		  9 = /dev/urandom	Faster, less secure random number gen.
 		 10 = /dev/aio		Asynchronous I/O notification interface
 		 11 = /dev/kmsg		Writes to this come out as printk's
+		 12 = /dev/oldmem	Used by crashdump kernels to access
+					the memory of the kernel that crashed.
 
   1 block	RAM disk
 		  0 = /dev/ram0		First RAM disk
-- 
http://www.codemonkey.org.uk
