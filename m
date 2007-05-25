Return-Path: <linux-kernel-owner+w=401wt.eu-S1763975AbXEYRZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763975AbXEYRZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbXEYRZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:25:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:60180 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbXEYRZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:25:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,580,1170662400"; 
   d="scan'208";a="247332390"
From: Auke Kok <auke-jan.h.kok@intel.com>
Subject: [PATCH 1/2] [CodingStyle] Add comment to not put spaces before tabs.
To: randy.dunlap@oracle.com
Cc: auke-jan.h.kok@intel.com, linux-kernel@vger.kernel.org
Date: Fri, 25 May 2007 10:25:09 -0700
Message-ID: <20070525172509.5138.56430.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2007 17:25:11.0034 (UTC) FILETIME=[A5DC65A0:01C79EF1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mixed space/tab indentation is wrong. Ironically this is what the coding
style document actually shows ;)

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
---

 Documentation/CodingStyle |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index afc2867..f518395 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -13,7 +13,7 @@ and NOT read it.  Burn them, it's a great symbolic gesture.
 Anyway, here goes:
 
 
-	 	Chapter 1: Indentation
+		Chapter 1: Indentation
 
 Tabs are 8 characters, and thus indentations are also 8 characters.
 There are heretic movements that try to make indentations 4 (or even 2!)
@@ -71,6 +71,8 @@ used for indentation, and the above example is deliberately broken.
 
 Get a decent editor and don't leave whitespace at the end of lines.
 
+Don't put spaces before tabs or mix them.
+
 
 		Chapter 2: Breaking long lines and strings
 
