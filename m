Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbXKUR5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbXKUR5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 12:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXKUR4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 12:56:53 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:38535 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbXKUR4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 12:56:52 -0500
Date: Wed, 21 Nov 2007 18:56:49 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
Message-ID: <20071121185649.03c78d2b@poseidon.drzeus.cx>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/card/block.c   |   22 +++++++++++++---------
 drivers/mmc/host/tifm_sd.c |   18 +++++++-----------
 2 files changed, 20 insertions(+), 20 deletions(-)

Alex Dubov (1):
      tifm_sd: handle non-power-of-2 block sizes

David Woodhouse (1):
      mmc: Avoid re-using minor numbers before the original device is closed.

Pierre Ossman (1):
      mmc_block: check card state after write


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
