Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbXJ0M4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbXJ0M4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 08:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbXJ0M4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 08:56:41 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:40868 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbXJ0M4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 08:56:41 -0400
Date: Sat, 27 Oct 2007 14:56:38 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMX update
Message-ID: <20071027145638.5e5da02a@poseidon.drzeus.cx>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/core/mmc_ops.c |   22 +++++++++++++++++-
 drivers/mmc/core/sd_ops.c  |    4 +-
 drivers/mmc/host/au1xmmc.c |    4 +-
 drivers/mmc/host/mmc_spi.c |   52 +++++++++++++++++++++++++++----------------
 4 files changed, 57 insertions(+), 25 deletions(-)

David Brownell (1):
      mmc_spi: Fix mmc-over-spi regression

Pierre Ossman (3):
      at91_mci: Fix bad reference
      mmc: fix cid and csd byte order
      mmc: use common byte swap macros

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
