Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbZLJAMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbZLJAMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758817AbZLJAMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:12:39 -0500
Received: from mail.perches.com ([173.55.12.10]:1062 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758700AbZLJAMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:12:39 -0500
Subject: MAINTAINERS: What's the correct mailing address?
From: Joe Perches <joe@perches.com>
To: devel@driverdev.osuosl.org
Cc: devel <devel@driverdev.osuosl.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259690373-12508-4-git-send-email-gregkh@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 16:12:45 -0800
Message-ID: <1260403965.5351.63.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I submitted patches to devel@driverdev.osuosl.org
on Sunday which are apparently still being held
for moderator approval.

Is that still the correct address or should
devel@linuxdriverproject.org be used instead?

If so, perhaps this is appropriate:

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ea781c1..5ad7830 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5061,8 +5061,9 @@ S:	Maintained
 
 STAGING SUBSYSTEM
 M:	Greg Kroah-Hartman <gregkh@suse.de>
+L:	devel@linuxdriverproject.org
+W:	http://linuxdriverproject.org/
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
-L:	devel@driverdev.osuosl.org
 S:	Maintained
 F:	drivers/staging/
 



