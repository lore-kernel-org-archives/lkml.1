Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbYCIX4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbYCIX4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 19:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbYCIX4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 19:56:15 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4363 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbYCIX4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 19:56:14 -0400
Subject: [PATCH] include/net/route.h - remove duplicate include
From: Joe Perches <joe@perches.com>
To: netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 16:55:15 -0700
Message-Id: <1205106915.656.100.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

 include/net/route.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index eadad59..28dba92 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -34,7 +34,6 @@
 #include <linux/ip.h>
 #include <linux/cache.h>
 #include <linux/security.h>
-#include <net/sock.h>
 
 #ifndef __KERNEL__
 #warning This file is not supposed to be used outside of kernel.


