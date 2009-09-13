Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbZIMTqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbZIMTqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 15:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZIMTqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 15:46:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:28878 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbZIMTqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 15:46:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gQ+tiSttL6px4sMNRrapPESbpzWvbKqEFJ25groRaNOPX184akgpMvGCE5oeDu6FLP
         pWKFz4JU6WuguBDlPa/C0Q2eg9jpeRYCDUA3GLEuAkxcHzl/AW9dsihLTfQAvE+GeVf9
         CMXfX3B7kbdoP+6EvtqM6/NnuI7lk+FzOgX50=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Perches <joe@perches.com>
Subject: [PATCH] MAINTAINERS: acpi: add 'include/acpi'
Date: Sun, 13 Sep 2009 22:46:17 +0300
Message-Id: <1252871178-5220-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 989ff11..c028237 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -233,6 +233,7 @@ S:	Supported
 F:	drivers/acpi/
 F:	drivers/pnp/pnpacpi/
 F:	include/linux/acpi.h
+F:	include/acpi/
 
 ACPI BATTERY DRIVERS
 M:	Alexey Starikovskiy <astarikovskiy@suse.de>
-- 
1.6.5.rc1

