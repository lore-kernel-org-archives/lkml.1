Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZFDM2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZFDM2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbZFDM20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:28:26 -0400
Received: from defg500.nifty.com ([202.248.238.127]:64236 "EHLO
	defg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbZFDM2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:28:25 -0400
X-Greylist: delayed 762 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2009 08:28:25 EDT
X-Nifty-SrcIP: [218.226.44.251]
Date: Thu, 04 Jun 2009 21:12:29 +0900 (JST)
Message-Id: <20090604.211229.31648111.ZAP03216@nifty.ne.jp>
To: abhay_salunke@dell.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/dell_rbu.txt: remove a period from end of
 command-line
From: Masanori Kobayasi <zap03216@nifty.ne.jp>
X-Mailer: Mew version 6.2.51 on Emacs 23.0.50 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While translating Documentation/dell_rbu.txt into Japanese,
a period of end of command-line is pointed out by
a proofreader.

Documentation/dell_rbu.txt: remove a period from end of command-line.

Signed-off-by: Masanori Kobayasi <zap03216@nifty.ne.jp>
---

diff --git a/Documentation/dell_rbu.txt b/Documentation/dell_rbu.txt
index c11b931..e9a6f2e 100644
--- a/Documentation/dell_rbu.txt
+++ b/Documentation/dell_rbu.txt
@@ -76,7 +76,7 @@ Do the steps below to download the BIOS image.

 The /sys/class/firmware/dell_rbu/ entries will remain till the following is
 done.
-echo -1 > /sys/class/firmware/dell_rbu/loading.
+echo -1 > /sys/class/firmware/dell_rbu/loading
 Until this step is completed the driver cannot be unloaded.
 Also echoing either mono ,packet or init in to image_type will free up the
 memory allocated by the driver.
