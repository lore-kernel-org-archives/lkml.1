Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbYLCHXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbYLCHXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYLCHXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:23:41 -0500
Received: from smtp1.stealer.net ([88.198.224.204]:40824 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbYLCHXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:23:40 -0500
Date: Wed, 3 Dec 2008 08:23:30 +0100 (CET)
From: Sven Wegener <sven.wegener@stealer.net>
To: rpurdie@rpsys.net
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] leds: Fixup kdoc comment to match parameter names
Message-ID: <alpine.LNX.2.00.0812030822480.23445@titan.stealer.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Wed, 03 Dec 2008 07:23:38 +0000
	Bayes: 0.4945 Tokens: new, 140; hammy, 2; neutral, 1; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4945]
X-Spam-Signature: ac17bd762e87238e596012a595caa65ea2a7b153
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/leds/led-class.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 6c4a326..1553d93 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -93,7 +93,7 @@ EXPORT_SYMBOL_GPL(led_classdev_resume);
 
 /**
  * led_classdev_register - register a new object of led_classdev class.
- * @dev: The device to register.
+ * @parent: The device to register.
  * @led_cdev: the led_classdev structure for this device.
  */
 int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
