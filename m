Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab0CLV6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 16:58:25 -0500
Received: from smtprelay-h11.telenor.se ([62.127.194.4]:48792 "EHLO
	smtprelay-h11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab0CLV6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 16:58:23 -0500
X-SMTPAUTH-B2: 
X-SENDER-IP: 83.226.248.36
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao85ALZHmktT4vgkPGdsb2JhbACHYZMIDAEBAQE3La4yjVWEewQ
X-IronPort-AV: E=Sophos;i="4.49,628,1262559600"; 
   d="scan'208";a="49487823"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: Renamed README to TODO and corrected Pavel's mail
Date: Fri, 12 Mar 2010 22:58:19 +0100
Message-Id: <1268431099-18367-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


diff --git a/drivers/staging/winbond/README b/drivers/staging/winbond/README
deleted file mode 100644
index cb944e4..0000000
--- a/drivers/staging/winbond/README
+++ /dev/null
@@ -1,11 +0,0 @@
-TODO:
-	- sparse cleanups
-	- checkpatch cleanups
-	- kerneldoc cleanups
-	- remove typedefs
-	- remove unused ioctls
-	- use cfg80211 for regulatory stuff
-	- fix 4k stack problems
-
-Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
-Pavel Machek <pavel@suse.cz>
diff --git a/drivers/staging/winbond/TODO b/drivers/staging/winbond/TODO
new file mode 100644
index 0000000..f4fb3f3
--- /dev/null
+++ b/drivers/staging/winbond/TODO
@@ -0,0 +1,11 @@
+TODO:
+	- sparse cleanups
+	- checkpatch cleanups
+	- kerneldoc cleanups
+	- remove typedefs
+	- remove unused ioctls
+	- use cfg80211 for regulatory stuff
+	- fix 4k stack problems
+
+Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
+Pavel Machek <pavel@ucw.cz>
