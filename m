Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbZDNWbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbZDNWbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZDNWa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:30:58 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:48228 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZDNWa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gEJl6g8qH9ohrYM24tbzU5zIjx6qtnIa2AzErsvWWpHjsO9J8xA3TdeM7iyX9+tSur
         DujYUPJxrnrwfzkBn1uKJLqY8YG2nFrGmMhUrMiLWptNJRX5WsQqGC+KcFKSE1OF8K+B
         ahMGMHWXi+/kOX919OCc0UzvyOQngGlWQRAd0=
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 2/2] Staging:  b3dfg: remove unused #include <linux/version.h>
Date: Wed, 15 Apr 2009 06:30:53 +0800
Message-Id: <1239748253-2180-1-git-send-email-weiyi.huang@gmail.com>
X-Mailer: git-send-email 1.6.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused #include <linux/version.h> in drivers/staging/b3dfg/b3dfg.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/staging/b3dfg/b3dfg.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/b3dfg/b3dfg.c b/drivers/staging/b3dfg/b3dfg.c
index 75ebe33..ddade6c 100644
--- a/drivers/staging/b3dfg/b3dfg.c
+++ b/drivers/staging/b3dfg/b3dfg.c
@@ -35,7 +35,6 @@
 #include <linux/poll.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
-#include <linux/version.h>
 #include <linux/uaccess.h>
 
 static unsigned int b3dfg_nbuf = 2;
-- 
1.6.1.2

