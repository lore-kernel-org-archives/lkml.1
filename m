Return-Path: <linux-kernel-owner+w=401wt.eu-S965754AbXHIOeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965754AbXHIOeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939945AbXHIOeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:34:23 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44158 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939277AbXHIOeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:34:21 -0400
Date: Thu, 9 Aug 2007 16:34:18 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
Message-ID: <20070809163418.4aedfdcd@poseidon.drzeus.cx>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/card/queue.c    |   14 +++++++-------
 drivers/mmc/host/at91_mci.c |    8 ++++----
 drivers/mmc/host/wbsd.c     |   10 +++++-----
 3 files changed, 16 insertions(+), 16 deletions(-)

Gabriel C (1):
      wbsd: fix section mismatch warnings

Nicolas Ferre (1):
      mmc: at91_mci: remove whitespace at the end of lines

Pierre Ossman (1):
      mmc: reorganize bounce buffer init

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
