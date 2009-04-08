Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbZDHNU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbZDHNU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbZDHNUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:20:12 -0400
Received: from mga10.intel.com ([192.55.52.92]:25069 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754224AbZDHNUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:20:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,344,1235980800"; 
   d="scan'208";a="446124517"
Subject: [GIT PULL] LED bugfix
From: Richard Purdie <rpurdie@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 14:20:10 +0100
Message-Id: <1239196810.5339.31.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for an LED bugfix.

Thanks, Richard

 drivers/leds/leds-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

David Brownell (1):
      leds: just ignore invalid GPIOs in leds-gpio


