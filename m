Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0BBEGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 23:06:36 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:55217 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0BBEGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 23:06:34 -0500
Date: Tue, 2 Feb 2010 13:06:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.33-rc7
Message-ID: <20100202040628.GH13428@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.33

Which contains:

Magnus Damm (1):
      usb: r8a66597-hdc disable interrupts fix

Marek Skuczynski (2):
      sh: Fix access to released memory in dwarf_unwinder_cleanup()
      sh: Fix access to released memory in clk_debugfs_register_one()

Markus Pietrek (1):
      spi: spi_sh_msiof: Fixed data sampling on the correct edge

 arch/sh/kernel/cpu/clock.c      |    4 ++--
 arch/sh/kernel/dwarf.c          |    8 ++++----
 drivers/spi/spi_sh_msiof.c      |   15 ++++++---------
 drivers/usb/host/r8a66597-hcd.c |   17 ++++++++++++++++-
 4 files changed, 28 insertions(+), 16 deletions(-)
