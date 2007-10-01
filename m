Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbXJAKvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbXJAKvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbXJAKux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:50:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34301 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXJAKux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:50:53 -0400
Date: Mon, 01 Oct 2007 06:37:57 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB update
Message-Id: <1191231717.20111.58.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For one bug fix at ivtv driver.

Cheers,
Mauro.

---

 drivers/media/video/ivtv/ivtv-fileops.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

Ian Armstrong (1):
      V4L/DVB (6052): ivtv: fix udma yuv bug

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

