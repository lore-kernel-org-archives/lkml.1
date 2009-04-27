Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbZD0IWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbZD0IWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZD0IWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:22:44 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39787 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZD0IWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:22:43 -0400
Date: Mon, 27 Apr 2009 17:17:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.30-rc4
Message-ID: <20090427081727.GC26020@linux-sh.org>
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

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.30

Which contains:

Adrian McMenamin (1):
      maple: input: fix up maple mouse driver

Paul Mundt (1):
      sh: Fix up unsigned syscall_nr in SH-5 pt_regs.

Yoshihiro Shimoda (1):
      sh: sh7785lcr: fix defconfig for 29-bit mode

 arch/sh/configs/sh7785lcr_defconfig |   57 ++++++++++++++++++++++------------
 arch/sh/include/asm/ptrace.h        |    2 +-
 drivers/input/mouse/maplemouse.c    |   43 ++++++++++++++------------
 3 files changed, 61 insertions(+), 41 deletions(-)
