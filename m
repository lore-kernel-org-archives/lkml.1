Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbYEQLsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbYEQLsE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 07:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYEQLrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 07:47:55 -0400
Received: from server.drzeus.cx ([85.8.24.28]:60916 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751635AbYEQLry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 07:47:54 -0400
Date: Sat, 17 May 2008 13:47:21 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates for 2.6.26-rc2
Message-ID: <20080517134721.6d93982c@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/card/Kconfig    |   12 +
 drivers/mmc/card/Makefile   |    1 +
 drivers/mmc/card/mmc_test.c |  892 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/at91_mci.c |    5 +-
 drivers/mmc/host/omap.c     |   12 +-
 5 files changed, 915 insertions(+), 7 deletions(-)

Marc Pignat (1):
      at91_mci: minor cleanup

Pierre Ossman (1):
      mmc: mmc host test driver

Tony Lindgren (1):
      mmc: Fix omap compile by replacing dev_name with dma_dev_name

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
