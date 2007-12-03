Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbXLCXhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbXLCXhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbXLCXg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:36:57 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:9095 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750764AbXLCXg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:36:56 -0500
Date: Tue, 4 Dec 2007 08:36:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.24-rc4, part 2.
Message-ID: <20071203233637.GC15047@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.24.git

Which contains:

Nobuhiro Iwamatsu (2):
      sh: Fix PCI IO space base address of SH7780.
      sh: Support PCI IO access of SH7780 base boards.

 arch/sh/drivers/pci/ops-r7780rp.c |    4 ++--
 arch/sh/drivers/pci/ops-se7780.c  |    4 ++--
 arch/sh/drivers/pci/pci-sh7780.h  |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)
