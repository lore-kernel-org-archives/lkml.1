Return-Path: <linux-kernel-owner+w=401wt.eu-S1161504AbXBOWSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161504AbXBOWSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161506AbXBOWSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:18:24 -0500
Received: from tim.rpsys.net ([194.106.48.114]:42840 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161504AbXBOWSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:18:23 -0500
Subject: [GIT PULL] LED updates
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 15 Feb 2007 22:18:11 +0000
Message-Id: <1171577892.5839.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

This adds two new LED drivers (in my capacity as LEDs maintainer).

Thanks,

Richard

 drivers/leds/Kconfig       |   12 +++
 drivers/leds/Makefile      |    2
 drivers/leds/leds-cobalt.c |   43 +++++++++++
 drivers/leds/leds-h1940.c  |  163
+++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 220 insertions(+)

Arnaud Patard (1):
      leds: Add IPAQ h1940 LEDs support

Florian Fainelli (1):
      leds: Add support for Cobalt Server front LED


