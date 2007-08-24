Return-Path: <linux-kernel-owner+w=401wt.eu-S1765849AbXHXJpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765849AbXHXJpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 05:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758861AbXHXJp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 05:45:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60953 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbXHXJp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 05:45:27 -0400
Date: Fri, 24 Aug 2007 11:45:13 +0200
From: andre@finow14.de
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Andre Haupt <andre@finow14.de>
Subject: [patch trivial] fix typo in Documentation/SubmittingPatches
Message-ID: <20070824094513.GA14451@ahaupt-debian-vm.localdomain>
References: <20070824093648.585376833@finow14.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=fix_typo_in_SubmittingPatches
User-Agent: quilt/0.45-1
X-Provags-ID: V01U2FsdGVkX18iKyNDaQc4u4fRVHSqvEP7J+HOsr0++s75TP1
 C5zNsKLvMPgDjxUwdQ7IJtbFBawEeh2uvl++e2GhPcc77y/iH3
 f26iY7wEoIGy2QhDOA6Qo/ambBap9lF
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Haupt <andre@finow14.de>
Signed-off-by: Andre Haupt <andre@finow14.de>
---
Index: linus/Documentation/SubmittingPatches
===================================================================
--- linus.orig/Documentation/SubmittingPatches	2007-08-24 11:12:33.000000000 +0200
+++ linus/Documentation/SubmittingPatches	2007-08-24 11:13:51.000000000 +0200
@@ -126,7 +126,7 @@
 without even being read.
 
 At a minimum you should check your patches with the patch style
-checker prior to submission (scripts/patchcheck.pl).  You should
+checker prior to submission (scripts/checkpatch.pl).  You should
 be able to justify all violations that remain in your patch.
 
 

--
