Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZDNAb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZDNAb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZDNAbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:31:51 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3273 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZDNAbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:31:50 -0400
Subject: Re: [PATCH] add ptrace entry to MAINTAINERS
From: Joe Perches <joe@perches.com>
To: Christoph Hellwig <hch@lst.de>
Cc: torvalds@osdl.org, roland@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090413152010.GA16682@lst.de>
References: <20090413152010.GA16682@lst.de>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 17:30:11 -0700
Message-Id: <1239669011.32203.62.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 17:20 +0200, Christoph Hellwig wrote:
> At the LF collab summit we decided to make Roland official ptrace
> maintainer not just the defacto one he has been for a couple of years
> now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

After a couple of emails with Roland,
now with file patterns...

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 29d74f4..df42699 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4448,6 +4448,21 @@ M:	jim@jtan.com
 L:	cbe-oss-dev@ozlabs.org
 S:	Maintained
 
+PTRACE SUPPORT
+P:	Roland McGrath
+M:	roland@redhat.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	arch/x86/*/ptrace*
+F:	arch/x86/*/*/ptrace*
+F:	arch/powerpc/*/ptrace*
+F:	arch/powerpc/*/*/ptrace*
+F:	include/asm-generic/syscall.h
+F:	include/linux/ptrace.h
+F:	include/linux/regset.h
+F:	include/linux/tracehook.h
+F:	kernel/ptrace.c
+
 PVRUSB2 VIDEO4LINUX DRIVER
 P:	Mike Isely
 M:	isely@pobox.com


