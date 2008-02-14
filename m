Return-Path: <linux-kernel-owner+w=401wt.eu-S1765282AbYBNUId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765282AbYBNUId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbYBNUIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:08:23 -0500
Received: from smtp-out.google.com ([216.239.33.17]:51551 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689AbYBNUIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:08:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:content-type:content-transfer-encoding;
	b=MZNXtAD4kJMUDcih+NO79EUTOy8Dz8b01URCTr9EPUXXz21UfMMi0rQ4Hcbjh4dMx
	eHxdWxkRyvzkRH9qENHxw==
Message-ID: <47B49FA8.20102@google.com>
Date: Thu, 14 Feb 2008 12:08:08 -0800
From: Paul Menage <menage@google.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
Subject: [PATCH] Add linux-fsdevel to VFS entry in MAINTAINERS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add linux-fsdevel to the VFS entry in MAINTAINERS

Signed-off-by: Paul Menage <menage@google.com>

---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6.24-mm1-bindflags/MAINTAINERS
===================================================================
--- 2.6.24-mm1-bindflags.orig/MAINTAINERS
+++ 2.6.24-mm1-bindflags/MAINTAINERS
@@ -1616,6 +1616,7 @@ S:	Maintained
 FILESYSTEMS (VFS and infrastructure)
 P:	Alexander Viro
 M:	viro@zeniv.linux.org.uk
+L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 
 FIREWIRE SUBSYSTEM (drivers/firewire, <linux/firewire*.h>)
