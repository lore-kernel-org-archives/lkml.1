Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbYBGKiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbYBGKiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYBGKiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:38:08 -0500
Received: from tim.rpsys.net ([194.106.48.114]:36442 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbYBGKiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:38:07 -0500
Subject: [GIT PULL] Backlight updates
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 10:37:49 +0000
Message-Id: <1202380670.9519.24.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-backlight for-linus

for the backlight tree updates for 2.6.25. This includes a new driver
and an optimisation for the class. Both changes have been testing in -mm
for quite a while.

Thanks, Richard

 drivers/video/backlight/Kconfig     |    9 +
 drivers/video/backlight/Makefile    |    1 
 drivers/video/backlight/backlight.c |   12 +-
 drivers/video/backlight/omap1_bl.c  |  210 ++++++++++++++++++++++++++++++++++++
 4 files changed, 228 insertions(+), 4 deletions(-)

Andrzej Zaborowski (1):
      backlight: Add OMAP1 PWL backlight driver

Helge Deller (1):
      backlight: Avoid unecessary driver callbacks


