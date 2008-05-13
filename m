Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbYEMEhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbYEMEhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 00:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYEMEhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 00:37:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59273 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYEMEhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 00:37:12 -0400
Message-ID: <48291AE7.9050108@jp.fujitsu.com>
Date: Tue, 13 May 2008 13:36:55 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] doc: Test-by?
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commonly used is "Tested-by."

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 Documentation/SubmittingPatches |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 9c93a03..037e8b8 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -359,7 +359,7 @@ person it names.  This tag documents that potentially interested parties
 have been included in the discussion
 
 
-14) Using Test-by: and Reviewed-by:
+14) Using Tested-by: and Reviewed-by:
 
 A Tested-by: tag indicates that the patch has been successfully tested (in
 some environment) by the person named.  This tag informs maintainers that
-- 
1.5.4.3

