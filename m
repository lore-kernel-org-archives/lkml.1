Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbXCPNBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbXCPNBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 09:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933643AbXCPNBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 09:01:30 -0400
Received: from relay4.usu.ru ([194.226.235.39]:40360 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932933AbXCPNB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 09:01:29 -0400
Message-ID: <45FA9539.7060301@ums.usu.ru>
Date: Fri, 16 Mar 2007 18:01:45 +0500
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Bunk <bunk@stusta.de>
Subject: [PATCH][TRIVIAL] Typo in usr/Kconfig
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander E. Patrakov

--- linux/usr/Kconfig	2007-02-20 11:34:32.000000000 +0500
+++ linux/usr/Kconfig	2007-03-16 17:57:16.000000000 +0500
@@ -17,7 +17,7 @@
 	  When multiple directories and files are specified then the
 	  initramfs image will be the aggregate of all of them.
 
-	  See <file:Documentation/early-userspace/README for more details.
+	  See <file:Documentation/early-userspace/README> for more details.
 
 	  If you are not sure, leave it blank.
 


