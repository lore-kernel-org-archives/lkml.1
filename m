Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbXDBQsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbXDBQsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 12:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933372AbXDBQsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 12:48:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58938 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347AbXDBQsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 12:48:07 -0400
Date: Mon, 02 Apr 2007 12:44:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] Two DVB fixes for 2.6.21 and -stable
Message-Id: <1175532441.4564.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1.1mdv2007.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following:

   - Tda10086: fix DiSEqC message length
   - Pluto2: fix incorrect TSCR register setting

Cheers,
Mauro.

---

 drivers/media/dvb/frontends/tda10086.c |    2 +-
 drivers/media/dvb/pluto2/pluto2.c      |   22 ++++++++++++++--------
 2 files changed, 15 insertions(+), 9 deletions(-)

Andreas Oberritter:
      V4L/DVB (5495): Tda10086: fix DiSEqC message length
      V4L/DVB (5496): Pluto2: fix incorrect TSCR register setting

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

