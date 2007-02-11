Return-Path: <linux-kernel-owner+w=401wt.eu-S1750699AbXBKPdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750699AbXBKPdc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 10:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbXBKPdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 10:33:32 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:58415 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbXBKPdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 10:33:31 -0500
Message-ID: <45CF374F.9040101@drzeus.cx>
Date: Sun, 11 Feb 2007 16:33:35 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
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

 drivers/mmc/sdhci.c   |   40 ++++++++++++----------------------------
 drivers/mmc/tifm_sd.c |   11 ++++-------
 drivers/mmc/wbsd.c    |    6 +-----
 3 files changed, 17 insertions(+), 40 deletions(-)

Alex Dubov (1):
      tifm_sd: treat "status error" as normal command completion

Pierre Ossman (4):
      mmc: wbsd: Remove driver version
      mmc: sdhci: Remove driver version
      mmc: sdhci: Stop asking for mail
      mmc: wbsd: Remove stray kunmap_atomic()

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
