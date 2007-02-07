Return-Path: <linux-kernel-owner+w=401wt.eu-S1161394AbXBGRSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161394AbXBGRSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 12:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161393AbXBGRSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 12:18:48 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56182 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161390AbXBGRSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 12:18:47 -0500
Date: Wed, 7 Feb 2007 09:18:30 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sk98lin: planned removal
Message-ID: <20070207091830.59f72f46@oldman>
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Document planned removal of sk98lin driver.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
---
 Documentation/feature-removal-schedule.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0ba6af0..d08a4af 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -325,3 +325,10 @@ Why:	Unmaintained for years, superceded 
 Who:	Jeff Garzik <jeff@garzik.org>
 
 ---------------------------
+
+What:   sk98lin network driver
+When:   July 2007
+Why:    In kernel tree version of driver is unmaintained. Sk98lin driver
+	replaced by the skge driver. 
+Who:    Stephen Hemminger <shemminger@osdl.org>
+
-- 
1.4.1

