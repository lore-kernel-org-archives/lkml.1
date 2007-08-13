Return-Path: <linux-kernel-owner+w=401wt.eu-S940051AbXHMI2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940051AbXHMI2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966774AbXHMG3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:14 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4603 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966606AbXHMG3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:11 -0400
Date: Sun, 12 Aug 2007 23:28:59 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mikulas@artax.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [229/2many] MAINTAINERS - HPFS FILESYSTEM
Message-ID: <46bffa2b.AOekOr4cWxCIUVwF%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e9bacf0..1ea3fec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2179,6 +2179,7 @@ P:	Mikulas Patocka
 M:	mikulas@artax.karlin.mff.cuni.cz
 W:	http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi
 S:	Maintained
+F:	fs/hpfs/
 
 HUGETLB FILESYSTEM
 P:	William Irwin
