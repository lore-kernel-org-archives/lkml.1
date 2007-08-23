Return-Path: <linux-kernel-owner+w=401wt.eu-S1764584AbXHWRLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764584AbXHWRLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXHWRLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:11:02 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54245 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbXHWRLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:11:01 -0400
Date: Thu, 23 Aug 2007 14:04:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
Message-Id: <1187889049.6833.24.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90-1mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For a regression fix at b2c2-flexcop and a warning fix at dvb_net.

Cheers,
Mauro.

---

 drivers/media/dvb/b2c2/flexcop-i2c.c |    7 +++++++
 drivers/media/dvb/dvb-core/dvb_net.c |    5 +++--
 2 files changed, 10 insertions(+), 2 deletions(-)

Mauro Carvalho Chehab (1):
      V4L/DVB (6070): Fix a warning at dvb_net

Trent Piepho (1):
      V4L/DVB (6042): b2c2-flexcop: fix Airstar HD5000 tuning regression

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

