Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYBDNsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYBDNsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYBDNnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:43:06 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:30309 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbYBDNm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=X9ZoEqej0dED+gdSMX3qJMK78N5V4EvLjzrD0K+whF7AWOizxDuR9vMCRSgeGEm+hrMepdtjrxkQKxpoPpFeSvuQ8scOKvHJP32O8G7hAFzk+Xn1g/e934OB0ZFFifS0PhZcohEXsRklM1CRpIQYM0eKFkS0jd3EW5mKmyn5NsE=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 21/22] ide-tape: bump minor driver version
Date: Mon,  4 Feb 2008 14:40:39 +0100
Message-Id: <1202132440-26648-22-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 5c88885..2e6198f 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -15,7 +15,7 @@
  * Documentation/ide/ChangeLog.ide-tape.1995-2002
  */
 
-#define IDETAPE_VERSION "1.19"
+#define IDETAPE_VERSION "1.20"
 
 #include <linux/module.h>
 #include <linux/types.h>
-- 
1.5.3.7

