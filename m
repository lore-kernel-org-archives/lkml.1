Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbYAARPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbYAARPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYAARPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:15:41 -0500
Received: from tim.rpsys.net ([194.106.48.114]:54466 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbYAARPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:15:41 -0500
Subject: [GIT PULL] LED bugfixes
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 01 Jan 2008 17:15:21 +0000
Message-Id: <1199207722.4653.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for a couple of LED oops fixes for 2.6.24.

Thanks, Richard

 drivers/leds/led-class.c    |    8 ++++----
 drivers/leds/led-core.c     |    4 ++--
 drivers/leds/led-triggers.c |    8 ++++----
 drivers/leds/leds-locomo.c  |    2 +-
 drivers/leds/leds.h         |    3 ++-
 5 files changed, 13 insertions(+), 12 deletions(-)

Richard Purdie (2):
      leds: Fix leds_list_lock locking issues
      leds: Fix locomo LED driver oops


