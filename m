Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbYJMQZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbYJMQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYJMQZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:25:16 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10395 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbYJMQZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:25:14 -0400
Date: Mon, 13 Oct 2008 09:24:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: move F: line so that it does not break S: line
 info
Message-Id: <20081013092458.3b478242.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Move F: line so that it doesn't break the S: line and its
explanations.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Jianjun Kong <kongjianjun@gmail.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lin2627-g3-kdocfixes.orig/MAINTAINERS
+++ lin2627-g3-kdocfixes/MAINTAINERS
@@ -72,8 +72,8 @@ M: Mail patches to
 L: Mailing list that is relevant to this area
 W: Web-page with status/info
 T: SCM tree type and location.  Type is one of: git, hg, quilt.
-S: Status, one of the following:
 F: Applicable files and/or directories
+S: Status, one of the following:
 
 	Supported:	Someone is actually paid to look after this.
 	Maintained:	Someone actually looks after it.
