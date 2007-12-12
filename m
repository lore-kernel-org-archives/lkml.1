Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbXLLKvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbXLLKvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbXLLKvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:51:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52040 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbXLLKvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:51:37 -0500
Date: Wed, 12 Dec 2007 08:23:34 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fix
Message-Id: <1197456388.4807.23.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following:

   - Re-adds lock safe videobuf_read_start

Cheers,
Mauro.

---

 drivers/media/video/videobuf-core.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

Mauro Carvalho Chehab (1):
      V4L/DVB (6609): Re-adds lock safe videobuf_read_start

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

