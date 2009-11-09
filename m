Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbZKIB6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbZKIB6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 20:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZKIB6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 20:58:06 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:46616 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZKIB6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 20:58:04 -0500
Date: Mon, 9 Nov 2009 10:57:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.32-rc7
Message-ID: <20091109015742.GB22932@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.32

Which contains:

Magnus Damm (1):
      serial: sh-sci: disable callback typo fix

Matt Fleming (1):
      sh: Account for cache aliases in flush_icache_range()

Paul Mundt (1):
      sh: unwinder: Fix up invalid PC refetch in dwarf unwinder.

Thomas Gleixner (1):
      sh: Replace old style lock initializer

 arch/sh/include/asm/rwsem.h |    2 +-
 arch/sh/kernel/dwarf.c      |    2 +-
 arch/sh/mm/cache-sh4.c      |    5 ++++-
 drivers/serial/sh-sci.c     |    2 +-
 4 files changed, 7 insertions(+), 4 deletions(-)
