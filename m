Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbYERIl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbYERIl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 04:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbYERIlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 04:41:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:50127 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYERIlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 04:41:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JZRAkyQrNDlfqbKnlWHosZ3WbY0kYypohEgkANmw4WhXjaIMu5RPJnQJIlaNH/aCS+cba+f6Qj/w+22JiCRhf7PbfWCncuk1j6mzALo/7wgnWkyJgrRfElOsn7KiKvNhBgSm5qhimx61953yk4Wv6XEmdLYuuDffpEJd6Ak+17U=
From: Jianjun Kong <kongjianjun@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jianjun Kong <kongjianjun@gmail.com>
Subject: [PATCH] spelling of Linus
Date: Sun, 18 May 2008 16:41:41 +0800
Message-Id: <12111001012896-git-send-email-kongjianjun@gmail.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: 0001-spelling-of-Linus.patch
References: 0001-spelling-of-Linus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change "linus" to "Linus".

Signed-off-by: Jianjun Kong <kongjianjun@gmail.com>
---
 drivers/serial/mux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/mux.c b/drivers/serial/mux.c
index e940317..9e13136 100644
--- a/drivers/serial/mux.c
+++ b/drivers/serial/mux.c
@@ -356,7 +356,7 @@ static int mux_request_port(struct uart_port *port)
  * Perform any autoconfiguration steps for the port.  This function is
  * called if the UPF_BOOT_AUTOCONF flag is specified for the port.
  * [Note: This is required for now because of a bug in the Serial core.
- *  rmk has already submitted a patch to linus, should be available for
+ *  rmk has already submitted a patch to Linus, should be available for
  *  2.5.47.]
  */
 static void mux_config_port(struct uart_port *port, int type)
-- 
1.5.2.5

