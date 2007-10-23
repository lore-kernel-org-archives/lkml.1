Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbXJWJw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbXJWJw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbXJWJwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:52:21 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53538
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751985AbXJWJwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:52:20 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] Add missing section ID to lsm.tmpl
Date: Tue, 23 Oct 2007 04:51:47 -0500
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, ssmalley@nai.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710230451.47649.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add missing section ID to lsm.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/DocBook/lsm.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -r a868e8217782 Documentation/DocBook/lsm.tmpl
--- a/Documentation/DocBook/lsm.tmpl	Mon Oct 22 19:40:02 2007 -0700
+++ b/Documentation/DocBook/lsm.tmpl	Tue Oct 23 04:41:31 2007 -0500
@@ -33,7 +33,7 @@
  </authorgroup>
  </articleinfo>
 
-<sect1><title>Introduction</title>
+<sect1 id="Introduction"><title>Introduction</title>
 
 <para>
 In March 2001, the National Security Agency (NSA) gave a presentation

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
