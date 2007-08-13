Return-Path: <linux-kernel-owner+w=401wt.eu-S969419AbXHMI1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969419AbXHMI1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966522AbXHMG3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:12 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4601 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966764AbXHMG3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:10 -0400
Date: Sun, 12 Aug 2007 23:28:57 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       bob.picco@hp.com, akpm@linux-foundation.org
Subject: [PATCH] [228/2many] MAINTAINERS - HPET:	ACPI hpet.c
Message-ID: <46bffa29.+9sT2/HCzkcrz8ZF%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2ef927b..e9bacf0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2172,6 +2172,7 @@ HPET:	ACPI hpet.c
 P:	Bob Picco
 M:	bob.picco@hp.com
 S:	Maintained
+F:	drivers/char/hpet.c
 
 HPFS FILESYSTEM
 P:	Mikulas Patocka
