Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYGWXlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYGWXlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbYGWXlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:41:11 -0400
Received: from tim.rpsys.net ([194.106.48.114]:44440 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbYGWXlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:41:08 -0400
Subject: [GIT PULL] Backlight updates for 2.6.26
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 00:39:49 +0100
Message-Id: <1216856389.7981.72.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-backlight for-linus

for the backlight tree updates for 2.6.26. This includes a new driver
and a doc fix. These have seen extensive testing in -mm/-next.

Thanks, Richard

 drivers/video/backlight/Kconfig         |    9 ++
 drivers/video/backlight/Makefile        |    2 
 drivers/video/backlight/backlight.c     |    1 
 drivers/video/backlight/mbp_nvidia_bl.c |  116 ++++++++++++++++++++++++++++++++
 4 files changed, 128 insertions(+)

Matthew Garrett (1):
      backlight: Add Nvidia-based Apple Macbook Pro backlight driver

Sebastian Siewior (1):
      backlight: Fix missing kernel doc entry



