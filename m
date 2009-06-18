Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZFRSzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZFRSzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZFRSzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:55:00 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1598 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZFRSy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:54:59 -0400
Subject: [PATCH] MAINTAINERS: pair names/addresses in EDAC-I82975X
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ranganathan Desikan <rdesikan@jetzbroadband.com>,
       "Arvind R." <arvind@acarlab.com>, bluesmoke-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Thu, 18 Jun 2009 11:54:57 -0700
Message-Id: <1245351297.29927.13.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fb94add..e139389 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2052,8 +2052,8 @@ F:	drivers/edac/i5400_edac.c
 
 EDAC-I82975X
 P:	Ranganathan Desikan
-P:	Arvind R.
 M:	rdesikan@jetzbroadband.com
+P:	Arvind R.
 M:	arvind@acarlab.com
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net


