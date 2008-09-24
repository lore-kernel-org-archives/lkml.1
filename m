Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbYIXOrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYIXOrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 10:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYIXOrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 10:47:39 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:40160 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYIXOrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 10:47:39 -0400
Message-ID: <48DA5317.9030705@novell.com>
Date: Wed, 24 Sep 2008 08:47:51 -0600
From: John Jolly <jjolly@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: axboe@kernel.dk
CC: Jan Blunck <JBlunck@novell.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] block: installing include/linux/blktrace_api.h
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Jolly <jjolly@novell.com>

Added line to install include/linux/blktrace_api.h during 'make headers_install'

Signed-off-by: John Jolly <jjolly@novell.com>
CC: Jan Blunck <JBlunck@novell.com>
---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index b68ec09..f1e5fa1 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -41,6 +41,7 @@ header-y += baycom.h
 header-y += bfs_fs.h
 header-y += blkpg.h
 header-y += bpqether.h
+header-y += blktrace_api.h
 header-y += can.h
 header-y += cdk.h
 header-y += chio.h
