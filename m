Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbYIUUu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbYIUUu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbYIUUso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:48:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:58768 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbYIUUsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:48:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:x-pgp-key:user-agent:sender;
        b=h/JKJpHZWqHh4VjFYeHOa9lSOevN/s51uYrXdjCB1VzE3BeAKoMN2BonwzUdPV9db7
         Y1VOuN9ErdPvElSXEyDYK2XYIRSSW/kxAlCh3T+M92AnoAO4vv7ReGbNwIs63bhjR0dr
         Q2FjMvML5WdZE0n6VXwQzh07mnlJA18BHv+BM=
Date: Sun, 21 Sep 2008 22:47:25 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] MAINTAINERS: add entry for uvesafb
Message-ID: <20080921204725.GB21215@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a maintainer entry for the uvesafb driver.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index 0a613cb..26c8ddb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4431,6 +4431,13 @@ W:	http://kernel.org/~kzak/util-linux-ng/
 T:	git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
 S:	Maintained
 
+UVESAFB DRIVER
+P:	Michal Januszewski
+M:	spock@gentoo.org
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+W:	http://dev.gentoo.org/~spock/projects/uvesafb/
+S:	Maintained
+
 VFAT/FAT/MSDOS FILESYSTEM:
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp

