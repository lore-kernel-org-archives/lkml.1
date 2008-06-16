Return-Path: <linux-kernel-owner+w=401wt.eu-S1758406AbYFPNlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbYFPNlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbYFPNkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:40:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbYFPNkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:40:40 -0400
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andre Haupt <andre@bitwigglers.org>
Subject: [PATCH] istallion: remove unused variable
Date: Mon, 16 Jun 2008 15:40:32 +0200
Message-Id: <1213623634-8120-1-git-send-email-andre@bitwigglers.org>
X-Mailer: git-send-email 1.5.5.GIT
X-Provags-ID: V01U2FsdGVkX18mo/cwZTGekmOQvoOUyB7QMbnBPY5Woz4UMzU
 3y84UnHbmXLX7U8BHsuIO8hza9q2MQjZkfXtIVsQWqWc1/ayTB
 QwvZ2UDzm0xfvbDW2jzjYGrLHYywq9a56Y24eZGg2A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
---
 drivers/char/istallion.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 7c8b62f..5ecefae 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -1660,7 +1660,6 @@ static int stli_ioctl(struct tty_struct *tty, struct file *file, unsigned int cm
 {
 	struct stliport *portp;
 	struct stlibrd *brdp;
-	unsigned int ival;
 	int rc;
 	void __user *argp = (void __user *)arg;
 
-- 
1.5.5.GIT

