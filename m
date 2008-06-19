Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbYFSMoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbYFSMoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbYFSMoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:44:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:54638 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbYFSMoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:44:02 -0400
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: johnpol@2ka.mipt.ru, linux-crypto@vger.kernel.org,
       Andre Haupt <andre@bitwigglers.org>
Subject: [PATCH] crypto: remove duplicate include of linux/interrupt.h
Date: Thu, 19 Jun 2008 14:43:08 +0200
Message-Id: <1213879388-11418-1-git-send-email-andre@bitwigglers.org>
X-Mailer: git-send-email 1.5.5.GIT
X-Provags-ID: V01U2FsdGVkX1+JdJHQmLu/shQ5ztpIwfyVRGe26ph0lg98+se
 NzUnWG44Cg7e3m1Spd3DwinSlUpOt1IctATKsxfRQseXi34TJx
 rK9a5tosdXW2dZ/jhbSvtaIfhvo3l0vyxdqhN1FPHg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
---
 drivers/crypto/hifn_795x.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 81f3f95..9bf8559 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -29,7 +29,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
 #include <linux/highmem.h>
-#include <linux/interrupt.h>
 #include <linux/crypto.h>
 #include <linux/hw_random.h>
 #include <linux/ktime.h>
-- 
1.5.5.GIT

