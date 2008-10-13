Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbYJMDUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbYJMDUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 23:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbYJMDUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 23:20:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:47581 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYJMDUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 23:20:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Bq5YpDhucGAyaiBZeObBbDwiS0B5L8Nkg97keUJdY4TGRVksiOziidPUGnsMgE8ggx
         zkmbJYtckeO5Ozf/QQPe+vdxXske7SRMn9PGmmq8pQwlhmWnxkFzzQxOrIYRWFEXzSSK
         T+f02U5K+XUDQN1jrCMOsfrdt+b+jBx8Ci92E=
Date: Mon, 13 Oct 2008 11:20:41 +0800
From: Jianjun Kong <kongjianjun@gmail.com>
To: randy.dunlap@oracle.com
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: [PATH] MAINTAINERS Move the sentence to right position
Message-ID: <20081013032041.GA7598@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianjun Kong <kongjianjun@gmail.com>

There is a list of status follow "S:...", so "F:..." must be move to end.

Signed-off-by: Jianjun Kong <kongjianjun@gmail.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fb1aad7..97c6387 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -73,7 +73,6 @@ L: Mailing list that is relevant to this area
 W: Web-page with status/info
 T: SCM tree type and location.  Type is one of: git, hg, quilt.
 S: Status, one of the following:
-F: Applicable files and/or directories
 
 	Supported:	Someone is actually paid to look after this.
 	Maintained:	Someone actually looks after it.
@@ -84,6 +83,7 @@ F: Applicable files and/or directories
 	Obsolete:	Old code. Something tagged obsolete generally means
 			it has been replaced by a better system and you
 			should be using that.
+F: Applicable files and/or directories
 
 3C505 NETWORK DRIVER
 P:	Philip Blundell
-- 
1.5.2.5

