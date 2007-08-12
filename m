Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbXHLD0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbXHLD0d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 23:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758390AbXHLD0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 23:26:07 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:58564 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757501AbXHLD0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 23:26:04 -0400
Date: Sun, 12 Aug 2007 12:23:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh64 updates for 2.6.23-rc3
Message-ID: <20070812032341.GB13496@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh64-2.6.git

Which contains:

Jesper Juhl (1):
      sh64: arch/sh64/kernel/signal.c: duplicate include removal

Michal Piotrowski (1):
      sh64: arch/sh64/kernel/setup.c: duplicate include removal.

Paul Mundt (1):
      sh64: Add missing dma_sync_single_for_*().

 arch/sh64/kernel/setup.c       |    4 ----
 arch/sh64/kernel/signal.c      |    1 -
 include/asm-sh64/dma-mapping.h |   18 ++++++++++++++++++
 3 files changed, 18 insertions(+), 5 deletions(-)
