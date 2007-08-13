Return-Path: <linux-kernel-owner+w=401wt.eu-S944154AbXHMMNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944154AbXHMMNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967548AbXHMGkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:45 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2511 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967460AbXHMGkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:21 -0400
Date: Sun, 12 Aug 2007 23:40:08 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, middelin@polyware.nl,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [555/2many] MAINTAINERS - ZR36120 VIDEO FOR LINUX DRIVER
Message-ID: <46bffcc8.d8w+CnlCwY/ZPE2s%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d291a71..f4d5119 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5252,6 +5252,7 @@ M:	middelin@polyware.nl
 W:	http://www.polyware.nl/~middelin/En/hobbies.html
 W:	http://www.polyware.nl/~middelin/hobbies.html
 S:	Maintained
+F:	drivers/media/video/saa7110.c
 
 ZS DECSTATION Z85C30 SERIAL DRIVER
 P:	Maciej W. Rozycki
