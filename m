Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbYERLgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbYERLgg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 07:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYERLg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 07:36:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:28839 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbYERLg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 07:36:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oOfNvGAJvoaRSvdVTWrd3NpvlOlvm8mO3XoGIhuAmHj2LkXdFpgYVt/YFWZBxWhibwEW9AC1C3qWzaqp9fBsbqpF6fdMs7MEVhD358cvh+1C4vEEpv4+1Pr5yxM/S0i7Q7ogecV9cGPHQu62TWTs/OocfXdhnAAX9lb5dHE+OeE=
From: Jianjun Kong <kongjianjun@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jianjun Kong <kongjianjun@gmail.com>
Subject: [PATCH] spelling of Linus
Date: Sun, 18 May 2008 19:36:24 +0800
Message-Id: <1211110584663-git-send-email-kongjianjun@gmail.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: 0001-spelling-of-Linus.patch
References: 0001-spelling-of-Linus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change of initials.
"rmk" -> "RMK"
"linus" -> "Linus".

Signed-off-by: Jianjun Kong <kongjianjun@gmail.com>
---
 drivers/serial/mux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/mux.c b/drivers/serial/mux.c
index e940317..b259b07 100644
--- a/drivers/serial/mux.c
+++ b/drivers/serial/mux.c
@@ -356,7 +356,7 @@ static int mux_request_port(struct uart_port *port)
  * Perform any autoconfiguration steps for the port.  This function is
  * called if the UPF_BOOT_AUTOCONF flag is specified for the port.
  * [Note: This is required for now because of a bug in the Serial core.
- *  rmk has already submitted a patch to linus, should be available for
+ *  RMK has already submitted a patch to Linus, should be available for
  *  2.5.47.]
  */
 static void mux_config_port(struct uart_port *port, int type)
-- 
1.5.2.5

