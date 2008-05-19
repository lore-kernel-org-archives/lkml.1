Return-Path: <linux-kernel-owner+w=401wt.eu-S1765581AbYESWLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765581AbYESWLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765222AbYESWHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:07:34 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45135 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765274AbYESWHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:07:32 -0400
Date: Tue, 20 May 2008 01:05:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] include/linux/mount.h: remove CVS keyword
Message-ID: <20080519220526.GK17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an CVS keyword that wasn't updated for a long time 
from a comment.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
023ddaa65448ffc93a3f90c1ff37d39c0af3cfa4 diff --git a/include/linux/mount.h b/include/linux/mount.h
index 4374d1a..f526b78 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -5,8 +5,6 @@
  *
  * Author:  Marco van Wieringen <mvw@planets.elm.net>
  *
- * Version: $Id: mount.h,v 2.0 1996/11/17 16:48:14 mvw Exp mvw $
- *
  */
 #ifndef _LINUX_MOUNT_H
 #define _LINUX_MOUNT_H

