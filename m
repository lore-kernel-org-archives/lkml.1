Return-Path: <linux-kernel-owner+w=401wt.eu-S943513AbXHMMAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943513AbXHMMAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967502AbXHMGj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:59 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2446 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967419AbXHMGj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:57 -0400
Date: Sun, 12 Aug 2007 23:39:43 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mitr@volny.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [542/2many] MAINTAINERS - WISTRON LAPTOP BUTTON DRIVER
Message-ID: <46bffcaf.SArwyodXfwIWiDUv%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 4172b36..e1fd743 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5126,6 +5126,7 @@ WISTRON LAPTOP BUTTON DRIVER
 P:	Miloslav Trmac
 M:	mitr@volny.cz
 S:	Maintained
+F:	drivers/input/misc/wistron_btns.c
 
 WL3501 WIRELESS PCMCIA CARD DRIVER
 P:	Arnaldo Carvalho de Melo
