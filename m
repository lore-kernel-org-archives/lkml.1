Return-Path: <linux-kernel-owner+w=401wt.eu-S943278AbXHMJ0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943278AbXHMJ0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967026AbXHMGcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:25 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1155 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967009AbXHMGcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:19 -0400
Date: Sun, 12 Aug 2007 23:32:06 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [320/2many] MAINTAINERS - MODULE SUPPORT
Message-ID: <46bffae6.9XAx4FDCoEU6hu7F%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b4617f..3dbcc24 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3081,6 +3081,8 @@ P:	Rusty Russell
 M:	rusty@rustcorp.com.au
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	include/linux/module.h
+F:	kernel/module.c
 
 MOTION EYE VAIO PICTUREBOOK CAMERA DRIVER
 P:	Stelian Pop
