Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228Ab0AKLJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0AKLJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 06:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870Ab0AKLJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 06:09:45 -0500
Received: from mail.perches.com ([173.55.12.10]:1057 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab0AKLJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 06:09:44 -0500
Subject: [PATCH] MAINTAINERS: netfilter - Remove netfilter and
 netfilter-core lists
From: Joe Perches <joe@perches.com>
To: Patrick McHardy <kaber@trash.net>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <4B4B02BE.5060209@trash.net>
References: <cover.1262726222.git.joe@perches.com>
	 <bccf36219f3ea5a9b7565734bc87095bc986dbe0.1262726222.git.joe@perches.com>
	 <1262805798.1952.105.camel@Joe-Laptop.home>  <4B4B02BE.5060209@trash.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 03:09:43 -0800
Message-ID: <1263208183.1907.50.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 11:51 +0100, Patrick McHardy wrote:
> it's enough to CC netfilter-devel and optionally
> netdev on patches, netfilter and netfilter-core are unnecessary.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 745643b..860d04f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3742,8 +3742,6 @@ P:	Harald Welte
 P:	Jozsef Kadlecsik
 M:	Patrick McHardy <kaber@trash.net>
 L:	netfilter-devel@vger.kernel.org
-L:	netfilter@vger.kernel.org
-L:	coreteam@netfilter.org
 W:	http://www.netfilter.org/
 W:	http://www.iptables.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git




