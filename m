Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbYHUD05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbYHUD05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbYHUDQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:16:46 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50117 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbYHUDQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:16:07 -0400
Date: Wed, 20 Aug 2008 20:50:36 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808210250.m7L2oapx028341@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc4 19/27] mdb: add MAGIC_SYSRQ support for mdb to documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add MAGIC_SYSRQ support for mdb to documentation


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/Documentation/sysrq.txt	2008-07-13 15:51:29.000000000 -0600
+++ b/Documentation/sysrq.txt	2008-08-18 23:40:26.000000000 -0600
@@ -82,6 +82,8 @@
 
 'i'     - Send a SIGKILL to all processes, except for init.
 
+'j'	- Used by Jeff Merkey's Kernel Debugger (mdb) on x86 platforms.
+
 'k'     - Secure Access Key (SAK) Kills all programs on the current virtual
           console. NOTE: See important comments below in SAK section.
 
