Return-Path: <linux-kernel-owner+w=401wt.eu-S943861AbXHMLFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943861AbXHMLFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967376AbXHMGh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:29 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2002 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967362AbXHMGhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:08 -0400
Date: Sun, 12 Aug 2007 23:36:46 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       ionut@cs.columbia.edu, akpm@linux-foundation.org
Subject: [PATCH] [461/2many] MAINTAINERS - STARFIRE/DURALAN NETWORK DRIVER
Message-ID: <46bffbfe.GU81aNeVjOVr6MFE%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3c134fa..eead832 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4393,6 +4393,7 @@ STARFIRE/DURALAN NETWORK DRIVER
 P:	Ion Badulescu
 M:	ionut@cs.columbia.edu
 S:	Maintained
+F:	drivers/net/starfire*
 
 STARMODE RADIO IP (STRIP) PROTOCOL DRIVER
 W:	http://mosquitonet.Stanford.EDU/strip.html
