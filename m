Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbZJPRUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbZJPRUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZJPRSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:44 -0400
Received: from kroah.org ([198.145.64.141]:48649 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbZJPRSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:41 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:06 2009
Message-Id: <20091016171205.629484075@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Riku Voipio <riku.voipio@iki.fi>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [36/46] MAINTAINERS: Fix Riku Voipios address
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=maintainers-fix-riku-voipio-s-address.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit 05576a1e38e2d06dece32974c5218528d3fbc6e2 upstream.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Riku Voipio <riku.voipio@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1992,7 +1992,7 @@ S:	Maintained
 F:	fs/*
 
 FINTEK F75375S HARDWARE MONITOR AND FAN CONTROLLER DRIVER
-M:	Riku Voipio <riku.vipio@iki.fi>
+M:	Riku Voipio <riku.voipio@iki.fi>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	drivers/hwmon/f75375s.c


