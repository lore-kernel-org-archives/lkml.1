Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbYH2GWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbYH2GWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbYH2GP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:15:58 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59522 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYH2GPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:30 -0400
Date: Thu, 28 Aug 2008 23:47:42 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5lgTY016136@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5 21/29] mdb: add MAGIC_SYSRQ support for mdb to documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add MAGIC_SYSRQ support for mdb to documentation


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/Documentation/sysrq.txt	2008-07-13 15:51:29.000000000 -0600
+++ b/Documentation/sysrq.txt	2008-08-28 14:20:04.000000000 -0600
@@ -82,6 +82,8 @@
 
 'i'     - Send a SIGKILL to all processes, except for init.
 
+'j'	- Used by Jeff Merkey's Kernel Debugger (mdb).
+
 'k'     - Secure Access Key (SAK) Kills all programs on the current virtual
           console. NOTE: See important comments below in SAK section.
 
