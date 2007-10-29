Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbXJ2KwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbXJ2KwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 06:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbXJ2KwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 06:52:12 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:53644 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbXJ2KwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 06:52:11 -0400
Message-ID: <4725BB3A.9020208@bx.jp.nec.com>
Date: Mon, 29 Oct 2007 19:51:38 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: gregkh@suse.de, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 1/2] fix typo in SubmittingPatches
References: <47218DBC.8070404@bx.jp.nec.com> <47218E80.50700@bx.jp.nec.com>
In-Reply-To: <47218E80.50700@bx.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keiichi Kii <k-keiichi@bx.jp.nec.com>

Greg, could you replace old patch with new one?

Fix typo and insert " -- " between clauses.

Signed-off-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
Cc: Andy Whitcroft <apw@shadowen.org>
---
Index: trunk/Documentation/SubmittingPatches
===================================================================
--- trunk.orig/Documentation/SubmittingPatches
+++ trunk/Documentation/SubmittingPatches
@@ -464,8 +464,8 @@ section Linus Computer Science 101.
 Nuff said.  If your code deviates too much from this, it is likely
 to be rejected without further review, and without comment.
 
-Once significant exception is when moving code from one file to
-another in this case you should not modify the moved code at all in
+One significant exception is when moving code from one file to
+another -- in this case you should not modify the moved code at all in
 the same patch which moves it.  This clearly delineates the act of
 moving the code and your changes.  This greatly aids review of the
 actual differences and allows tools to better track the history of


-- 
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com
