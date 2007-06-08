Return-Path: <linux-kernel-owner+w=401wt.eu-S968655AbXFHIMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968655AbXFHIMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939239AbXFHIIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 04:08:11 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:39999 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939208AbXFHIIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 04:08:07 -0400
Message-ID: <46690EA9.30704@drzeus.cx>
Date: Fri, 08 Jun 2007 10:09:13 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/core/sd.c       |   26 +++++++++++++++++++++-----
 drivers/mmc/host/at91_mci.c |    5 ++---
 drivers/mmc/host/au1xmmc.c  |    3 +--
 3 files changed, 24 insertions(+), 10 deletions(-)

Marc Pignat (1):
      mmc-atmel: remove linux/mmc/protocol.h dependencies

Pierre Ossman (2):
      mmc: fix broken if clause
      mmc: don't call switch on old cards

Robert P. J. Day (1):
      au1xmmc: Replace C code with call to ARRAY_SIZE() macro.


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
