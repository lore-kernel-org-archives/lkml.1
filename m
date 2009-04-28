Return-Path: <linux-kernel-owner+w=401wt.eu-S1762843AbZD1Quc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762843AbZD1Quc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbZD1QuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:50:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:24016 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410AbZD1QuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:50:18 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] powerpc: Update MPC5xxx and Xilinx Virtex maintainer entries
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, tnt@246tNt.com
Date: Tue, 28 Apr 2009 10:50:15 -0600
Message-ID: <20090428165015.1410.47926.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

- Add git tree URLs
- Drop Sylvain from the 5xxx maintainers list.  He hasn't been active
  for a while now.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index ef03abe..4a8d367 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3434,11 +3434,10 @@ L:	linuxppc-dev@ozlabs.org
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED MPC5XXX
-P:	Sylvain Munaut
-M:	tnt@246tNt.com
 P:	Grant Likely
 M:	grant.likely@secretlab.ca
 L:	linuxppc-dev@ozlabs.org
+T:	git git://git.secretlab.ca/git/linux-2.6.git
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED PPC4XX
@@ -3456,6 +3455,7 @@ P:	Grant Likely
 M:	grant.likely@secretlab.ca
 W:	http://wiki.secretlab.ca/index.php/Linux_on_Xilinx_Virtex
 L:	linuxppc-dev@ozlabs.org
+T:	git git://git.secretlab.ca/git/linux-2.6.git
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED PPC8XX

