Return-Path: <linux-kernel-owner+w=401wt.eu-S1763937AbXEXFqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763937AbXEXFqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 01:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757859AbXEXFqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 01:46:10 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:34716 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757213AbXEXFqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 01:46:09 -0400
Message-ID: <465526A2.9070500@drzeus.cx>
Date: Thu, 24 May 2007 07:46:10 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] MMC updates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 MAINTAINERS              |   29 +++++++++++++++++++++++++++++
 drivers/mmc/card/block.c |   18 ------------------
 drivers/mmc/card/queue.c |   35 ++++++++---------------------------
 drivers/mmc/card/queue.h |    8 --------
 4 files changed, 37 insertions(+), 53 deletions(-)

Pavel Pisa (1):
      mmc: add maintainer for iMX MMC interface

Pierre Ossman (2):
      mmc: clean up unused parts of block driver
      mmc: mark unmaintained drivers

Russell King (1):
      mmc: add maintainer for ARM Primecell controller

Syed Khasim (1):
      mmc: Add maintainers for TI OMAP MMC interface


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
