Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbYGaIZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbYGaIZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 04:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYGaIZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 04:25:30 -0400
Received: from havoc.gtf.org ([69.61.125.42]:43598 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbYGaIZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 04:25:28 -0400
Date: Thu, 31 Jul 2008 04:25:27 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mchehab@infradead.org
Subject: [git patches] delete zero-length files
Message-ID: <20080731082527.GA22188@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"make distclean" keeps deleting these things, which in turn causes
"git status" to squawk.


Please pull from 'zero-len' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git zero-len

to receive the following updates:

 0 files changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 drivers/media/video/planb.c
 delete mode 100644 drivers/media/video/planb.h
 delete mode 100644 drivers/media/video/saa7196.h
 delete mode 100644 drivers/media/video/videodev.c
 delete mode 100644 include/media/audiochip.h

Jeff Garzik (1):
      drivers/media, include/media: delete zero-length files

diff --git a/drivers/media/video/planb.c b/drivers/media/video/planb.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/media/video/planb.h b/drivers/media/video/planb.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/media/video/saa7196.h b/drivers/media/video/saa7196.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/media/video/videodev.c b/drivers/media/video/videodev.c
deleted file mode 100644
index e69de29..0000000
diff --git a/include/media/audiochip.h b/include/media/audiochip.h
deleted file mode 100644
index e69de29..0000000
