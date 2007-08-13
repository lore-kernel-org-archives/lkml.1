Return-Path: <linux-kernel-owner+w=401wt.eu-S940522AbXHMHLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940522AbXHMHLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966111AbXHMGYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:38 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3834 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965847AbXHMGYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:33 -0400
Date: Sun, 12 Aug 2007 23:24:17 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rathamahata@php4.ru,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [92/2many] MAINTAINERS - BEFS FILE SYSTEM
Message-ID: <46bff911.AU+2ca/ovaTuI7Z3%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a7309a..2f452df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -937,6 +937,7 @@ P:	Sergey S. Kostyliov
 M:	rathamahata@php4.ru
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	fs/befs/
 
 BFS FILE SYSTEM
 P:	Tigran A. Aivazian
