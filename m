Return-Path: <linux-kernel-owner+w=401wt.eu-S938778AbXHMJfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938778AbXHMJfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967050AbXHMGcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:48 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1223 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967043AbXHMGcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:43 -0400
Date: Sun, 12 Aug 2007 23:32:30 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, shemminger@linux-foundation.org,
       netem@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [333/2many] MAINTAINERS - NETEM NETWORK EMULATOR
Message-ID: <46bffafe.x0iOtukfi7vYsjol%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 493de7a..7e3b438 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3184,6 +3184,7 @@ P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
 L:	netem@lists.linux-foundation.org
 S:	Maintained
+F:	net/sched/sch_netem.c
 
 NETFILTER/IPTABLES/IPCHAINS
 P:	Rusty Russell
