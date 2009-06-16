Return-Path: <linux-kernel-owner+w=401wt.eu-S1764773AbZFPCcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764773AbZFPCcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 22:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbZFPCcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 22:32:08 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:59435 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbZFPCcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 22:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lIoRugo1MU9hOIB7yItOdOpITT5CwV3d2oCKNb4V2kY+yK/wyZvnjUXAtfxEEbknND
         KRthgfHu8pF2kyoURqYBy1ECufp9AuLNxwTV8fEk8cEoQSvhlC1srP4CJvA/7jsLGwP3
         JEY2fl3TbCLwgEmvxPO3TpF5OaXsgn4GdJxG4=
Subject: [PATCH] libcap: Change address of the libcap source.
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew G.Morgan" <morgan@kernel.org>,
       Alexander Kjeldaas <astor@guardian.no>
Content-Type: text/plain
Organization: Private
Date: Tue, 16 Jun 2009 11:32:01 +0900
Message-Id: <1245119521.20635.105.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dear Jiri Kosina.

This is patch to change ftp site of the libcap source. 
Merge this patch. 


Regards,




Subject: [PATCH] Change ftp site of the libcap source.

This is about libcap Library for getting and setting POSIX.1e capabilities.
"ftp://linux.kernel.org" address does not exist no longer.

Before ) ftp://linux.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.6/
After  ) ftp://www.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.6/
         http://ftp.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.6/

         Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
---
 include/linux/capability.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index c302110..c8f2a5f 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -7,7 +7,7 @@
  *
  * See here for the libcap library ("POSIX draft" compliance):
  *
- * ftp://linux.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.6/
+ * ftp://www.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.6/
  */
 
 #ifndef _LINUX_CAPABILITY_H
-- 
1.6.3.1


 
-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim ( Samsung Electronics )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

