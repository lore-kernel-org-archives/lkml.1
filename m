Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbXJKVj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbXJKVj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756463AbXJKVjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:39:04 -0400
Received: from tim.rpsys.net ([194.106.48.114]:33807 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756325AbXJKVjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:39:03 -0400
Subject: [GIT PULL] LED updates
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 11 Oct 2007 22:38:13 +0100
Message-Id: <1192138693.11368.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for the LED tree updates for 2.6.24. Just some changes to the cobalt
driver really.

Thanks, Richard

 drivers/leds/Kconfig            |   13 ++-
 drivers/leds/Makefile           |    3 
 drivers/leds/leds-cobalt-qube.c |  102 +++++++++++++++++++++++++++++
 drivers/leds/leds-cobalt-raq.c  |  138 ++++++++++++++++++++++++++++++++++++++++
 drivers/leds/leds-cobalt.c      |   43 ------------
 5 files changed, 252 insertions(+), 47 deletions(-)

Yoichi Yuasa (3):
      leds: Rename leds-cobalt driver
      leds: Add Cobalt Raq series LEDs support
      leds: Update Cobalt Qube series front LED support


