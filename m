Return-Path: <linux-kernel-owner+w=401wt.eu-S932182AbYDYSBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbYDYSBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764796AbYDYR5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:17 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53128 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbYDYR5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:08 -0400
Date: Fri, 25 Apr 2008 13:56:14 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 13/19] UML - Remove unused header
Message-ID: <20080425175614.GA11196@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch removes the unused and broken (the normal asm/keyboard.h 
files no longer exists) include/asm-um/keyboard.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 include/asm-um/keyboard.h |    6 ------
 1 file changed, 6 deletions(-)

Index: linux-2.6.22/include/asm-um/keyboard.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/keyboard.h	2007-07-08 19:32:17.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,6 +0,0 @@
-#ifndef __UM_KEYBOARD_H
-#define __UM_KEYBOARD_H
-
-#include "asm/arch/keyboard.h"
-
-#endif
