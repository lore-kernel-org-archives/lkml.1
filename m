Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbYJHMoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbYJHMoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 08:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYJHMoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 08:44:06 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:46783 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbYJHMoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 08:44:05 -0400
Date: Wed, 8 Oct 2008 13:44:01 +0100
From: Nick Warne <nick@ukfsn.org>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] Trivial patch to submitting-patches Documantation
Message-ID: <20081008134401.68910c46@sauron.linicks.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diff'ed against 2.6.26.5 stable tree.

Test-by tag is wrong.

Signed-off-by: Nick Warne <nick@ukfsn.org>

--- linux-2.6.26.y/Documentation/SubmittingPatches	2008-10-08 13:36:07.000000000 +0100
+++ linux-2.6.26.y/Documentation/SubmittingPatchesNEW	2008-10-08 13:39:38.000000000 +0100
@@ -405,7 +405,7 @@
 have been included in the discussion
 
 
-14) Using Test-by: and Reviewed-by:
+14) Using Tested-by: and Reviewed-by:
 
 A Tested-by: tag indicates that the patch has been successfully tested (in
 some environment) by the person named.  This tag informs maintainers that

-- 
Free Software Foundation Associate Member 5508
