Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbXKEWWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbXKEWWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 17:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbXKEWVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 17:21:52 -0500
Received: from tim.rpsys.net ([194.106.48.114]:58030 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbXKEWVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 17:21:52 -0500
Subject: [GIT PULL] LED bugfixes
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, dbrownell@users.sourceforge.net
Content-Type: text/plain
Date: Mon, 05 Nov 2007 22:21:29 +0000
Message-Id: <1194301290.5564.126.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for some LED driver bugfixes for 2.6.24.

Thanks, Richard

 drivers/leds/leds-gpio.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

David Brownell (1):
      leds: bugfixes for leds-gpio


