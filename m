Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbZHBMub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbZHBMub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 08:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZHBMua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 08:50:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1523 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbZHBMu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 08:50:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=DjyFBBSmN+Y3VyD+5GKUvCCOxfcdn6trbh4XwuYwtGZhcC+/S7d8MVNqLyys2H86S
	voOXlB14KWQ/KWLI9musQ==
Subject: [PATCH] MAINTAINERS: add IPVS include files
To: Andrew Morton <akpm@linux-foundation.org>
From: Hannes Eder <heder@google.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Date: Sun, 02 Aug 2009 14:49:47 +0200
Message-ID: <20090802124843.5339.86283.stgit@jazzy.zrh.corp.google.com>
User-Agent: StGit/0.14.3.366.gf979
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hannes Eder <heder@google.com>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a50aa7f..4175d73 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2791,6 +2791,8 @@ L:	netdev@vger.kernel.org
 L:	lvs-devel@vger.kernel.org
 S:	Maintained
 F:	Documentation/networking/ipvs-sysctl.txt
+F:	include/net/ip_vs.h
+F:	include/linux/ip_vs.h
 F:	net/netfilter/ipvs/
 
 IPWIRELESS DRIVER

